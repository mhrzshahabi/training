/*
ghazanfari_f,
12/19/2019,
4:14 PM
*/
package com.nicico.training.controller.util;

import org.springframework.util.MultiValueMap;

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
}
