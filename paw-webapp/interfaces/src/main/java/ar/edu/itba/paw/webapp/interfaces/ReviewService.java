package ar.edu.itba.paw.webapp.interfaces;

import ar.edu.itba.paw.webapp.exceptions.NoSuchEntityException;
import ar.edu.itba.paw.webapp.exceptions.NoSuchGameException;
import ar.edu.itba.paw.webapp.exceptions.NoSuchUserException;
import ar.edu.itba.paw.webapp.model.Review;
import ar.edu.itba.paw.webapp.utilities.Page;

/**
 * Service layer for game reviews. Exposes functionality available to reviews.
 */
public interface ReviewService {


    /**
     * Returns a {@link Page} with the reviews, applying filters, pagination and sorting.
     *
     * @param gameIdFilter   Filter for game id.
     * @param gameNameFilter Filter for game name.
     * @param userIdFilter   Filter for user id.
     * @param userNameFilter Filter for user name.
     * @param pageNumber     The page number.
     * @param pageSize       The page size.
     * @param sortingType    The sorting type (id, game id, or creation date).
     * @param sortDirection  The sort direction (i.e ASC or DESC).
     * @return The resulting page.
     */
    Page<Review> getReviews(Long gameIdFilter, String gameNameFilter, Long userIdFilter, String userNameFilter,
                            int pageNumber, int pageSize,
                            ReviewDao.SortingType sortingType, SortDirection sortDirection);

    /**
     * Finds a review by ID.
     *
     * @param reviewId The ID to match.
     * @return The matching review or {@code null} if not found.
     */
    Review findById(long reviewId);

    /**
     * Creates a new review with the specified data.
     *
     * @param reviewerId    The id of the user who created the review.
     * @param gameId        The id of the game getting reviewed.
     * @param reviewBody    The textual review.
     * @param storyScore    The story score.
     * @param graphicsScore The graphics score.
     * @param audioScore    The audio score.
     * @param controlsScore The controls score.
     * @param funScore      The fun score.
     * @return The created review.
     * @throws NoSuchEntityException If no such user or game exists.
     *                               //TODO throw exception if said review already exists. <-- Un usuario no puede escribir dos reviews para un mismo juego? [JMB]
     */
    Review create(long reviewerId, long gameId, String reviewBody,
                  int storyScore, int graphicsScore, int audioScore, int controlsScore, int funScore)
            throws NoSuchEntityException;


    /**
     * Updates the {@link Review} with the given {@code reviewId}.
     *
     * @param reviewId      The review id.
     * @param reviewBody    The new review body.
     * @param storyScore    The new story score.
     * @param graphicsScore The new graphics score.
     * @param audioScore    The new audio score.
     * @param controlsScore The new controls score.
     * @param funScore      The new fun score.
     */
    void update(long reviewId, long updaterUserId, String reviewBody, Integer storyScore, Integer graphicsScore,
                Integer audioScore, Integer controlsScore, Integer funScore);

    /**
     * Deletes {@link Review} with the given {@code reviewId}.
     *
     * @param reviewId      The id of the review to be deleted.
     * @param deleterUserId
     */
    void delete(long reviewId, long deleterUserId);


    /**
     * Finds a review given a user ID and user ID.
     *
     * @param userId The user ID.
     * @param gameId The game ID.
     * @return The matching review, or {@code null} if not found.
     * @throws NoSuchUserException If an invalid user ID is provided.
     * @throws NoSuchUserException If an invalid game ID is provided.
     * @deprecated #getReviews includes this feature and, apart from that, this method returns a single Review,
     * but a given user can create several reviews for a given game, so a collection should be returned instead.
     */
    @Deprecated
    Review find(long userId, long gameId) throws NoSuchUserException, NoSuchGameException;

}