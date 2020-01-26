/*
ghazanfari_f, 8/29/2019, 1:48 PM
*/
package com.nicico.training.controller;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;
import org.apache.commons.lang3.StringUtils;
import org.springframework.data.domain.Page;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Getter
@Setter
public class ISC<T> {

    private final Response response;

    public ISC(Response response) {
        this.response = response;
    }

    public static SearchDTO.SearchRq convertToSearchRq(HttpServletRequest rq) throws IOException {

        SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq();
        String startRowStr = rq.getParameter("_startRow");
        String endRowStr = rq.getParameter("_endRow");
        String constructor = rq.getParameter("_constructor");
        String sortBy = rq.getParameter("_sortBy");
        String criteriaList = rq.getParameter("criteria");
        String operator = rq.getParameter("operator");

        Integer startRow = (startRowStr != null) ? Integer.parseInt(startRowStr) : 0;
        Integer endRow = (endRowStr != null) ? Integer.parseInt(endRowStr) : 50;

        searchRq.setStartIndex(startRow);
        searchRq.setCount(endRow - startRow);

        if (StringUtils.isNotEmpty(sortBy)) {
            searchRq.setSortBy(sortBy);
        }

        ObjectMapper objectMapper = new ObjectMapper();

        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
                criteriaList = "[" + criteriaList + "]";
            SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.valueOf(operator))
                    .setCriteria(objectMapper.readValue(criteriaList, new TypeReference<List<SearchDTO.CriteriaRq>>() {
                    }));
            searchRq.setCriteria(criteriaRq);
        }
        return searchRq;
    }

    public static <T> ISC<T> convertToIscRs(SearchDTO.SearchRs<T> searchRs, Integer startRow) {
        Response<T> response = new Response<T>();
        response.setData(searchRs.getList()).setStartRow(startRow)
                .setEndRow(startRow + searchRs.getTotalCount().intValue())
                .setTotalRows(searchRs.getTotalCount().intValue());
        return new ISC(response);
    }

    public static <T> ISC<T> convertToIscRs(Page<T> page, Integer startRow) {
        Response<T> response = new Response<T>();
        response.setData(page.getContent()).setStartRow(startRow)
                .setEndRow(startRow + page.getNumberOfElements())
                .setTotalRows((int) page.getTotalElements());
        return new ISC(response);
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    static class Response<T> {
        private List<T> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

}