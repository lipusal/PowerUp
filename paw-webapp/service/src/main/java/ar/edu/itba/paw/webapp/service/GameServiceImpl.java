package ar.edu.itba.paw.webapp.service;

import ar.edu.itba.paw.webapp.exceptions.NoSuchEntityException;
import ar.edu.itba.paw.webapp.interfaces.*;
import ar.edu.itba.paw.webapp.model.*;
import ar.edu.itba.paw.webapp.utilities.Page;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;


@Service
@Transactional
public class GameServiceImpl implements GameService {

    //    @Autowired
    private GameDao gameDao;

    private GenreDao genreDao;

    private PlatformDao platformDao;

    private CompanyDao companyDao;

//    private KeywordDao keywordDao; TODO: implement keyword dao

    @Autowired
    public GameServiceImpl(GameDao gameDao, GenreDao genreDao,
                           PlatformDao platformDao, CompanyDao companyDao/*, KeywordDao keywordDao*/) {
        this.gameDao = gameDao;
        this.genreDao = genreDao;
        this.platformDao = platformDao;
        this.companyDao = companyDao;
//        this.keywordDao = keywordDao;
    }

    @Override
    public Page<Game> searchGames(String name, Map<FilterCategory, List<String>> filters,
                                  OrderCategory orderCategory, boolean ascending, int pageSize, int pageNumber) {
        name = escapeUnsafeCharacters(name);
        Page<Game> page = gameDao.searchGames(name, filters, orderCategory, ascending, pageSize, pageNumber);
        page.getData().forEach(each -> gameDao.loadGenres(each).loadPlatforms(each));
        return page;
    }

    @Override
    public Collection<Game> findRelatedGames(long gameId, Set<FilterCategory> filters) {
        return gameDao.findRelatedGames(gameId, filters);
    }

    @Override
    public Game findById(long id) {
        return gameDao.findById(id);
    }

    @Override
    public boolean existsWithId(long id) {
        return gameDao.existsWithId(id);
    }

    @Override
    public boolean existsWithTitle(String title) {
        return gameDao.existsWithTitle(title);
    }

    public Collection<String> getFiltersByType(FilterCategory filterCategory) {
//        return gameDao.getFiltersByType(filterCategory);
        //Genres

        switch (filterCategory) {
            case genre:
                return genreDao.all().stream().map(Genre::getName).collect(Collectors.toList());
            case keyword:
                return new LinkedList<>();
            case platform:
                return platformDao.all().stream().map(Platform::getName).collect(Collectors.toList());
            case developer:
                return companyDao.all().stream().filter(each -> !each.getGamesDeveloped().isEmpty())
                        .map(Company::getName).collect(Collectors.toList());
            case publisher:
                return companyDao.all().stream().filter(each -> !each.getGamesPublished().isEmpty())
                        .map(Company::getName).collect(Collectors.toList());
        }
        throw new RuntimeException("Something went wrong");
    }

    @Override
    public Collection<Genre> getGenres(long gameId) {
        return gameDao.getGenres(gameId);
    }

    @Override
    public Map<Platform, GamePlatformReleaseDate> getPlatforms(long gameId) {
        return gameDao.getPlatforms(gameId);
    }

    @Override
    public Collection<Company> getPublishers(long gameId) {
        return gameDao.getPublishers(gameId);
    }

    @Override
    public Collection<Company> getDevelopers(long gameId) {
        return gameDao.getDevelopers(gameId);
    }

    @Override
    public Collection<Keyword> getKeywords(long gameId) {
        return gameDao.getKeywords(gameId);
    }

    @Override
    public Collection<Review> getReviews(long gameId) {
        return gameDao.getReviews(gameId);
    }

    @Override
    public Map<Long, Integer> getScores(long gameId) {
        return gameDao.getScores(gameId);
    }

    @Override
    public Map<String, String> getVideos(long gameId) throws NoSuchEntityException {
        return gameDao.getVideos(gameId);
    }

    @Override
    public Set<String> getPictureUrls(long gameId) throws NoSuchEntityException {
        return gameDao.getPictureUrls(gameId);
    }

    @Override
    public Map<Long, Game> findByIds(Collection<Long> ids) {
        return gameDao.findByIds(ids);
    }

    // TODO: Move to controller as this is a controller's task
    public String escapeUnsafeCharacters(String name) {
        char[] escape = new char[1];
        StringBuilder nameEscaped = new StringBuilder();
        for (int i = 0; i < name.length(); i++) {
            if (name.charAt(i) == '%' || name.charAt(i) == '_' || name.charAt(i) == '\\') {
                nameEscaped.append('\\');
            }
            nameEscaped.append(name.charAt(i));
        }
        return nameEscaped.toString();
    }

}
