package ar.edu.itba.paw.webapp.persistence;

import ar.edu.itba.paw.webapp.exceptions.FailedToProcessQueryException;
import ar.edu.itba.paw.webapp.exceptions.UserExistsException;
import ar.edu.itba.paw.webapp.interfaces.UserDao;
import ar.edu.itba.paw.webapp.model.Game;
import ar.edu.itba.paw.webapp.model.PlayStatus;
import ar.edu.itba.paw.webapp.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.*;
import org.springframework.jdbc.core.simple.SimpleJdbcInsert;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * Implementation of {@link ar.edu.itba.paw.webapp.interfaces.UserDao} oriented towards JDBC.
 */
@Repository
public class UserJdbcDao implements UserDao {

    private JdbcTemplate jdbcTemplate;
    private final SimpleJdbcInsert userCreator,
            gameScoreInserter,
            gamePlayStatusInserter;
    private final RowMapper<User> userRowMapper = new RowMapper<User>() {
        @Override
        public User mapRow(ResultSet rs, int rowNum) throws SQLException {
            return new User(rs.getLong("id"), rs.getString("email"), rs.getString("username"));
        }
    };


    @Autowired
    public UserJdbcDao(DataSource dataSource) {
        jdbcTemplate = new JdbcTemplate(dataSource);
        userCreator = new SimpleJdbcInsert(jdbcTemplate)
                .withSchemaName("power_up")
                .withTableName("users")
                .usingColumns("email", "username", "hashed_password")
                .usingGeneratedKeyColumns("id");
        gamePlayStatusInserter = new SimpleJdbcInsert(jdbcTemplate)
                .withSchemaName("power_up")
                .withTableName("game_play_statuses")
                .usingGeneratedKeyColumns("id");
        gameScoreInserter = new SimpleJdbcInsert(jdbcTemplate)
                .withSchemaName("power_up")
                .withTableName("game_scores")
                .usingGeneratedKeyColumns("id");
    }

    protected JdbcTemplate getJdbcTemplate() {
        return this.jdbcTemplate;
    }

    @Override
    public User create(String email, String password, String username) {
        if (email == null) {
            throw new IllegalArgumentException("Email can't be null");
        }
        if (password == null) {
            throw new IllegalArgumentException("Password can't be null");
        }
        if (username == null) {
            throw new IllegalArgumentException("Username can't be null");
        }

        if (rowExists("power_up.users", "email = '" + email + "'")) {
            throw new UserExistsException("Email " + email + " already taken");
        }
        if (rowExists("power_up.users", "username = '" + username + "'")) {
            throw new UserExistsException("Username " + username + " already taken");
        }

        final Map<String, Object> args = new HashMap<>();
        args.put("email", email);                  //TODO ensure it's a valid email
        args.put("hashed_password", password);     //TODO hash or salt the passwords here, DON'T STORE THEM IN PLAIN TEXT!
        args.put("username", username);
        try {
            Number id = userCreator.executeAndReturnKey(args);
            return new User(id.longValue(), email, username);
        } catch (Exception e) {
            throw new UserExistsException(e);
        }
    }

    @Override
    public User findByUsername(String username) {
        final String query = "SELECT * FROM power_up.users WHERE username = ? LIMIT 1";
        List<User> result;
        try {
            result = jdbcTemplate.query(query, userRowMapper, username);
        } catch (Exception e) {
            throw new FailedToProcessQueryException(e);
        }
        return result.isEmpty() ? null : completeUser(result.get(0));
    }

    @Override
    public User findByEmail(String email) {
        final String query = "SELECT * FROM power_up.users WHERE LOWER(email) = LOWER(?) LIMIT 1";
        List<User> result;
        try {
            result = jdbcTemplate.query(query, userRowMapper, email);
        } catch (Exception e) {
            throw new FailedToProcessQueryException(e);
        }
        return result.isEmpty() ? null : completeUser(result.get(0));
    }

    @Override
    public User findById(long id) {
        final String query = "SELECT * FROM power_up.users WHERE id = ? LIMIT 1";
        List<User> result;
        try {
            result = jdbcTemplate.query(query, userRowMapper, id);
        } catch (Exception e) {
            throw new FailedToProcessQueryException(e);
        }
        return result.isEmpty() ? null : completeUser(result.get(0));
    }

    @Override
    public void scoreGame(User user, long gameId, int score) {
        if (user == null) {
            throw new IllegalArgumentException("User can't be null");
        }
        //TODO make a function in GameDao that checks whether a game with a given ID exists
        if (!rowExists("power_up.games", "id = " + gameId)) {
            throw new IllegalArgumentException("No game with ID " + gameId);
        }
        if (score < 1 || score > 10) {
            throw new IllegalArgumentException("Score must be between 1 and 10");
        }

        //Update if exists, otherwise insert
        if (rowExists("power_up.game_scores", "user_id = " + user.getId() + " AND game_id = " + gameId)) {
            jdbcTemplate.update("UPDATE power_up.game_scores SET score = ? WHERE user_id = ? AND game_id = ?", score, user.getId(), gameId);
        } else {
            Map<String, Object> params = new HashMap<>();
            params.put("user_id", user.getId());
            params.put("game_id", gameId);
            params.put("score", score);
            gameScoreInserter.execute(params);
        }
        user.scoreGame(gameId, score);
    }

    @Override
    public void scoreGame(User user, Game game, int score) {
        if (game == null) {
            throw new IllegalArgumentException("Game can't be null");
        }
        scoreGame(user, game.getId(), score);
    }

    @Override
    public void setPlayStatus(User user, long gameId, PlayStatus status) {
        if (user == null) {
            throw new IllegalArgumentException("User can't be null");
        }
        if(status == null) {
            throw new IllegalArgumentException("Status can't be null");
        }
        //TODO make a function in GameDao that checks whether a game with a given ID exists
        if (!rowExists("power_up.games", "id = " + gameId)) {
            throw new IllegalArgumentException("No game with ID " + gameId);
        }

        //Update if exists, otherwise insert
        if (rowExists("power_up.game_play_status", "user_id = " + user.getId() + " AND game_id = " + gameId)) {
            jdbcTemplate.update("UPDATE power_up.game_play_statuses SET status = ? WHERE user_id = ? AND game_id = ?", status.name(), user.getId(), gameId);
        } else {
            Map<String, Object> params = new HashMap<>();
            params.put("user_id", user.getId());
            params.put("game_id", gameId);
            params.put("status", status.name());
            gamePlayStatusInserter.execute(params);
        }
        user.setPlayStatus(gameId, status);
    }

    @Override
    public void setPlayStatus(User user, Game game, PlayStatus status) {
        if (game == null) {
            throw new IllegalArgumentException("Game cannot be null");
        }
        setPlayStatus(user, game.getId(), status);
    }

    /**
     * Checks whether there is a row matching a specific condition on a special table.
     * TODO put this method in a more generic DAO, this can be used accross multiple tables.
     *
     * @param tableName The name of the table. Can include schema prefix.
     * @param whereClause Condition to meet.
     * @return Whether there is such a row in the specified table.
     */
    private boolean rowExists(String tableName, String whereClause) {
        final boolean[] result = {false};
        //No prepared statement here since this is run from a trusted source.
        jdbcTemplate.query("SELECT COUNT(*) AS ct FROM " + tableName + " WHERE " + whereClause, new RowCallbackHandler() {
            @Override
            public void processRow(ResultSet rs) throws SQLException {
                result[0] = rs.getInt("ct") > 0;
            }
        });
        return result[0];
    }

    /**
     * Adds relationship information for a specific user that is not readily available from the users table (e.g. scored
     * games, played games)
     *
     * @param u The user whose data to complete.
     * @return The completed user (returned value == u) so you can chain this call.
     */
    private User completeUser(User u) {
        //Scores
        Map<Long, Integer> scores = new HashMap<>();
        jdbcTemplate.query(
                "SELECT * FROM power_up.game_scores WHERE user_id = ?",
                new RowCallbackHandler() {
                    @Override
                    public void processRow(ResultSet rs) throws SQLException {
                        scores.put(rs.getLong("game_id"), rs.getInt("score"));
                    }
                },
                u.getId());
        u.setScoredGames(scores);

        //Played games
        Map<Long, PlayStatus> statuses = new HashMap<>();
        jdbcTemplate.query(
                "SELECT * FROM power_up.game_play_statuses WHERE user_id = ?",
                new RowCallbackHandler() {
                    @Override
                    public void processRow(ResultSet rs) throws SQLException {
                        statuses.put(rs.getLong("game_id"), PlayStatus.valueOf(rs.getString("status")));
                    }
                },
                u.getId());
        u.setPlayStatuses(statuses);

        return u;
    }
}