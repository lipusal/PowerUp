package ar.edu.itba.paw.webapp.persistence;

import ar.edu.itba.paw.webapp.interfaces.GameDao;
import ar.edu.itba.paw.webapp.model.FilterCategory;
import ar.edu.itba.paw.webapp.model.Game;
import org.atteo.evo.inflector.English;
import org.joda.time.LocalDate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowCallbackHandler;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;


/**
 * Data Access Object for games. Allows to search for games with specified criteria defined in {@link FilterCategory}.
 */
@Repository
public class GameJdbcDao implements GameDao {

    private JdbcTemplate jdbcTemplate;

    @Autowired
    public GameJdbcDao(DataSource dataSource) {
        jdbcTemplate = new JdbcTemplate(dataSource);
    }

    protected JdbcTemplate getJdbcTemplate(){
        return this.jdbcTemplate;
    }


    public Collection<Game> searchGame(String name, Map<FilterCategory, List<String>> filters) {

//        name.replace(' ', '%');
        String[] parameters = new String[countFilters(filters) + 1];
        parameters[0] = name;

        String tablesString = "SELECT power_up.games.id, power_up.games.name, avg_score, summary" +
                " FROM power_up.games" +
                " INNER JOIN power_up.game_platforms ON power_up.games.id = power_up.game_platforms.game_id" +
                " INNER JOIN power_up.platforms ON power_up.game_platforms.platform_id = power_up.platforms.id";
        String nameString = "WHERE LOWER(power_up.games.name) like '%' || LOWER(?) || '%'";
        String filtersString = "";
        String groupByString = "GROUP BY power_up.games.id, power_up.games.name, avg_score, summary HAVING ";



        int parameterCount = 1;         // Used for indexing parameters array
        boolean firstFilter = true;     // Used to check if an 'AND' must be added to the group by string
        for (FilterCategory filter : filters.keySet()) {

            List<String> values = filters.get(filter);
            if (values == null) {
                throw new IllegalArgumentException("A list must be specified for the filter" + filter.name());
            }

            int valuesSize = values.size();
            if (valuesSize > 0) {

                // Tables join string (Joins with specific table if a filter of that table is needed)
                if (!filter.equals(FilterCategory.platform)) { // table "platforms" is already joined
                    tablesString += " " + createJoinSentence(filter);
                }

                // Filters string
                filtersString += " AND ( ";

                boolean firstValue = true;      // Used to check if an 'OR' must be added to the filters string
                for (String value : values) {
                    if (!firstValue) {
                        filtersString += " OR ";
                    }
                    filtersString += createFilterSentence(filter);
                    parameters[parameterCount] = value;
                    parameterCount++;
                    firstValue = false;
                }
                filtersString += " )";

                // Group by string
                if (!firstFilter) {
                    groupByString += " AND ";
                }
                groupByString += createHavingSentence(filter, valuesSize);
                firstFilter = false;
            }
        }
        String query = tablesString + " " + nameString + filtersString;
        if (filters.size() > 0) {
            query += " " + groupByString;
        }
        query += ";";

        Set<Game> gamesSet = new HashSet<>();
        System.out.println(query);
        jdbcTemplate.query(query.toString().toLowerCase(), parameters, new RowCallbackHandler() {

            @Override
            public void processRow(ResultSet rs) throws SQLException {
                gamesSet.add(new Game(rs.getLong("id"), rs.getString("name"), rs.getString("summary")));
            }
        });
        return gamesSet;
    }


    @Override
    public Game findById(long id) {
        Game result = new Game();
        Object[] parameters = new Object[1];
        parameters[0] = id;
        String query;
        query = "SELECT power_up.games.id, power_up.games.name, summary, release, avg_score FROM power_up.games WHERE power_up.games.id = ?";
        final boolean[] found = {false};
        jdbcTemplate.query(query.toLowerCase(), parameters, new RowCallbackHandler() {
                    @Override
                    public void processRow(ResultSet rs) throws SQLException {
                        result.setId(rs.getLong("id"));
                        result.setName(rs.getString("name"));
                        result.setSummary(rs.getString("summary"));
                        result.setAvgScore(rs.getDouble("avg_score"));
                        result.setReleaseDate(new LocalDate(rs.getString("release")));
                        found[0] = true;
                    }
                }
        );
        if (!found[0]) {
            return null;
        }

        query = "SELECT power_up.platforms.name FROM power_up.games, power_up.platforms, power_up.game_platforms " +
                "WHERE power_up.games.id = ? AND power_up.game_platforms.game_Id = power_up.games.id AND power_up.game_platforms.platform_Id = power_up.platforms.id ";
        jdbcTemplate.query(query.toLowerCase(), parameters, new RowCallbackHandler() {
                    @Override
                    public void processRow(ResultSet rs) throws SQLException {
                        result.addPlatform(rs.getString("name"));

                    }
                }
        );
        query = "SELECT power_up.genres.name FROM power_up.games, power_up.genres, power_up.game_genres " +
                "WHERE power_up.games.id = ? AND power_up.game_genres.game_Id = power_up.games.id AND power_up.game_genres.genre_Id = power_up.genres.id ";
        jdbcTemplate.query(query.toLowerCase(), parameters, new RowCallbackHandler() {
                    @Override
                    public void processRow(ResultSet rs) throws SQLException {
                        result.addGenre(rs.getString("name"));
                    }
                }
        );
        query = "SELECT power_up.companies.name FROM power_up.games, power_up.companies, power_up.game_publishers " +
                "WHERE power_up.games.id = ? AND power_up.game_publishers.game_Id = power_up.games.id AND power_up.game_publishers.publisher_Id = power_up.companies.id ";
        jdbcTemplate.query(query.toLowerCase(), parameters, new RowCallbackHandler() {
                    @Override
                    public void processRow(ResultSet rs) throws SQLException {
                        result.addPublisher(rs.getString("name"));
                    }
                }
        );
        query = "SELECT power_up.companies.name FROM power_up.games, power_up.companies, power_up.game_developers " +
                "WHERE power_up.games.id = ? AND power_up.game_developers.game_Id = power_up.games.id AND power_up.game_developers.developer_Id = power_up.companies.id ";
        jdbcTemplate.query(query.toLowerCase(), parameters, new RowCallbackHandler() {
                    @Override
                    public void processRow(ResultSet rs) throws SQLException {
                        result.addDeveloper(rs.getString("name"));
                    }
                }
        );
        return result;
    }

    @Override
    public Collection<String> getFiltersByType(FilterCategory filterType) {
        HashSet<String> result = new HashSet<>();
        StringBuilder query = new StringBuilder().append("SELECT power_up.");
        StringBuilder fromSentence = new StringBuilder().append(" FROM power_up.");
        if (filterType != FilterCategory.developer && filterType != FilterCategory.publisher) {
            query.append(filterType.name());
            fromSentence.append(filterType.name());
        } else {
            query.append("companies");
            fromSentence.append("companies");
        }
        query.append(".name").append(fromSentence).append(" ORDER BY name ASC LIMIT 500");

        jdbcTemplate.query(query.toString().toLowerCase(), (Object[]) null, new RowCallbackHandler() {
                    @Override
                    public void processRow(ResultSet rs) throws SQLException {
                        result.add(rs.getString("name"));
                    }
                }
        );

        return result;
    }



    /**
     * Creates a join sentence to be added into the FROM clause.
     * @param filter The filter whose table (and the corresponding relation table) must be joined.
     * @return The created sentence.
     */
    private String createJoinSentence (FilterCategory filter) {

        String filterName = filter.name();
        String entityTable = getEntityTable(filter);
        String relationTable = "power_up.game_" + English.plural(filterName);

        String sentence = "INNER JOIN " + relationTable + " ON power_up.games.id = " + relationTable + ".game_id";
        sentence += " INNER JOIN " + entityTable
                + " ON " + relationTable + "." + filterName + "_id = " + entityTable + ".id";
        return sentence;
    }

    /**
     * Creates a sentence to be added to the WHERE clause.
     * <p>
     *     This sentence compares a given field (specified by the filter param)
     *     and a '?' param, that must be filled afterward in a parameters array.
     * </p>
     * @param filter The filter whose value must be checked
     * @return The created sentence.
     */
    private String createFilterSentence(FilterCategory filter) {
        return "LOWER(" + getEntityTable(filter) + ".name) = LOWER(?)";
    }

    /**
     * Creates a HAVING clause sentence to be added to the query.
     * <p>This sentence compares how many tuples there are that verify a given filter with a passed value</p>
     * @param filter The filter whose sum must be compared.
     * @param valuesCount The value to which the sum must be compared.
     * @return The created sentence.
     */
    private String createHavingSentence(FilterCategory filter, int valuesCount) {
        return "COUNT(DISTINCT " + getEntityTable(filter) + ".name) = " + valuesCount;
    }


    /**
     * Counts how many filters will be applied (i.e. for each filter type, how many values there are).
     * @param filters The map with the filters.
     * @return How many filters will be applied.
     */
    private int countFilters(Map<FilterCategory, List<String>> filters) {
        int count = 0;
        for (List<String> list : filters.values()) {
            count += list.size();
        }
        return count;
    }

    /**
     * Creates a string with the filter's entity table name.
     * @param filter The filter whose table name must be created.
     * @return A string containing the filter's entity table name.
     */
    private String getEntityTable(FilterCategory filter) {
        boolean useCompany = filter.equals(FilterCategory.developer) || filter.equals(FilterCategory.publisher);
        return "power_up." + (useCompany ? "companies": English.plural(filter.name()));
    }






}
