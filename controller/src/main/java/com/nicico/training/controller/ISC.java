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
import java.util.*;
import java.util.stream.Collectors;

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
        String[] criteriaList = rq.getParameterValues("criteria");
        String operator = rq.getParameter("operator");

        Integer startRow = (startRowStr != null) ? Integer.parseInt(startRowStr) : 0;
        Integer endRow = (endRowStr != null) ? Integer.parseInt(endRowStr) : 50;

        searchRq.setStartIndex(startRow);
        searchRq.setCount(endRow - startRow);

        if (rq.getParameterValues("_sortBy") != null) {
            searchRq.setSortBy(Arrays.asList(rq.getParameterValues("_sortBy")));
        }

        ObjectMapper objectMapper = new ObjectMapper();

        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
            StringBuilder criteria = new StringBuilder("[" + criteriaList[0]);
            for (int i = 1; i < criteriaList.length; i++) {
                criteria.append(",").append(criteriaList[i]);
            }
            criteria.append("]");
            SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.valueOf(operator))
                    .setCriteria(objectMapper.readValue(criteria.toString(), new TypeReference<List<SearchDTO.CriteriaRq>>() {
                    }));
            convertDate(criteriaRq);
            searchRq.setCriteria(criteriaRq);
        }
        return searchRq;
    }

    public static SearchDTO.SearchRq convertToSearchRq(HttpServletRequest rq, Object value, String fieldName, EOperator operator) throws IOException {

        SearchDTO.SearchRq searchRq = convertToSearchRq(rq);
        if (value != null) {
            SearchDTO.CriteriaRq criteria = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
            if (value instanceof Collection) {
                criteria.getCriteria().add(makeNewCriteria(null, null, EOperator.or, new ArrayList<>()));
                for (int i = 0; ((Collection) value).size() > i * 1000; i++) {
                    criteria.getCriteria().get(0).getCriteria().add(makeNewCriteria(fieldName, ((Collection) value).stream().skip(i * 1000).limit(1000).collect(Collectors.toList()), operator, null));
                }
            } else {
                criteria.getCriteria().add(makeNewCriteria(fieldName, value, operator, null));
            }
            if (searchRq.getCriteria() != null)
                criteria.getCriteria().add(searchRq.getCriteria());
            searchRq.setCriteria(criteria);
        }
        return searchRq;
    }

    public static <T> ISC<T> convertToIscRs(SearchDTO.SearchRs<T> searchRs, Integer startRow) {
        Response<T> response = new Response<T>();
        response.setData(searchRs.getList()).setStartRow(startRow)
                .setEndRow(startRow + searchRs.getList().size())
                .setTotalRows(searchRs.getTotalCount().intValue());
        return new ISC<>(response);
    }

    public static <T> ISC<T> convertToIscRs(Page<T> page, Integer startRow) {
        Response<T> response = new Response<T>();
        response.setData(page.getContent()).setStartRow(startRow)
                .setEndRow(startRow + page.getNumberOfElements())
                .setTotalRows((int) page.getTotalElements());
        return new ISC<>(response);
    }

    private static void convertDate(SearchDTO.CriteriaRq criteria) {
        if (criteria == null)
            return;
        if ("createdDate".equals(criteria.getFieldName()) ||
                "lastModifiedDate".equals(criteria.getFieldName()) ||
                "behavioralDueDate".equals(criteria.getFieldName())) {
            criteria.setValue(criteria.getValue().stream().map(o -> new Date(o.toString())).collect(Collectors.toList()));
        }
        if (criteria.getCriteria() != null)
            criteria.getCriteria().forEach(ISC::convertDate);
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