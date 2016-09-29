package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.webapp.interfaces.GameService;
import ar.edu.itba.paw.webapp.model.FilterCategory;
import ar.edu.itba.paw.webapp.model.Game;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class MainController {

    private final GameService gameService;


    private final static ObjectMapper objectMapper = new ObjectMapper();
    private final static TypeReference<HashMap<FilterCategory, ArrayList<String>>> typeReference
            = new TypeReference<HashMap<FilterCategory, ArrayList<String>>>() {};

    @Autowired
    public MainController(GameService gameService) {
        //Spring is in charge of providing the gameService parameter.
        this.gameService = gameService;
    }

    @RequestMapping("/")
    public ModelAndView home() {
        final ModelAndView mav = new ModelAndView("index");
        mav.addObject("greeting", "PAW");
        return mav;
    }


    @RequestMapping("/search")
    public ModelAndView search(@RequestParam(value = "name", required = false) String name,
                               @RequestParam(value = "filters", required = false) String filtersJson) {

        ModelAndView mav = new ModelAndView();

        if (filtersJson == null || filtersJson.equals("")) {
            filtersJson = "{}";
        }
        Map<FilterCategory, List<String>> filters = null;
        try {
            filters = objectMapper.readValue(filtersJson, typeReference);
            mav.setViewName("search");
            mav.addObject("results", gameService.searchGames(name, filters));
            mav.addObject("hasFilters", !filtersJson.equals("{}"));
            mav.addObject("appliedFilters", filters);
            mav.addObject("searchedName", name);
        } catch (IOException e) {
            e.printStackTrace();  // Wrong JSON!!
            mav.setViewName("error");
        }
        return mav;

//
//
//
////        final ModelAndView mav = new ModelAndView("search");
//
//
//
//        try {
//            filters = objectMapper.readValue(filtersJson, typeReference);
//            mav.addObject("results", gameService.searchGames(name, filters));
//            mav.addObject("hasFilters", !filtersJson.equals("{}"));
//            mav.addObject("searchedName", name);
//        } catch (IOException e) {
//            e.printStackTrace();  // Wrong JSON!!
//            //TODO: Send something into the ModelAndView indicating the error
//        }
//        return mav;
    }


    @RequestMapping("/advanced-search")
    public ModelAndView advancedSearch() {
        final ModelAndView mav = new ModelAndView("advanced-search");
        //Add all possible filter types
        for(FilterCategory filterCategory : FilterCategory.values()) {
            mav.addObject((filterCategory.name()+"s").toUpperCase(), gameService.getFiltersByType(filterCategory));
        }
        return mav;
    }

    @RequestMapping("/game")
    public ModelAndView game(@RequestParam(name = "id") int id) {
        final ModelAndView mav = new ModelAndView("game");
        Game game = gameService.findById(id);
        mav.addObject("game", game);
        return mav;
    }
}