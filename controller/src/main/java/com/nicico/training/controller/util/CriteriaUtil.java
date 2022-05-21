/*
ghazanfari_f,
12/19/2019,
4:14 PM
*/
package com.nicico.training.controller.util;

import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import org.springframework.util.MultiValueMap;

import java.util.List;

public class CriteriaUtil {

    public static MultiValueMap<String, String> addCriteria(MultiValueMap<String, String> criteria, String fieldName, String operator, String value) {
        String criteriaPart = "{\"fieldName\":\"" + fieldName + "\",\"operator\":\"" + operator + "\",\"value\":\"" + value + "\"}";
        if (criteria.get("criteria") == null) {
            criteria.add("criteria", criteriaPart);
        } else {
            criteria.get("criteria").add(criteriaPart);
        }
        return criteria;
    }
    public static SearchDTO.CriteriaRq addCriteria(List<SearchDTO.CriteriaRq> listOfCriteria, EOperator criteriaOperator) {
        SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();
        criteriaRq.setCriteria(listOfCriteria);
        criteriaRq.setOperator(criteriaOperator);
        return criteriaRq;
    }
    public static SearchDTO.CriteriaRq createCriteria(EOperator operator, String fieldName, Object value) {
        SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();
        criteriaRq.setOperator(operator);
        criteriaRq.setFieldName(fieldName);
        criteriaRq.setValue(value);
        return criteriaRq;
    }

}
