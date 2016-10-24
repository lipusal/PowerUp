package ar.edu.itba.paw.webapp.interfaces;

import ar.edu.itba.paw.webapp.model.Game;

import java.util.Set;

/**
 * Created by Juan Marcos Bellini on 19/10/16.
 * Questions at jbellini@itba.edu.ar or juanmbellini@gmail.com
 *
 * Data Access Object for Game Developers
 */
public interface DeveloperDao {


    /**
     * Returns a set of developers for the given game.
     *
     * @param game The game whose developers will be returned.
     * @return The set of developers for the given game.
     */
    Set<String> getGameDevelopers(Game game);

    /**
     * Returns a set of developers for the game with the given id.
     *
     * @param gameId The game's id whose developers. will be returned.
     * @return The set of developers for the game with the given if.
     */
    Set<String> getGameDevelopers(long gameId);
}
