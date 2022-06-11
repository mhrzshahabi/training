/*
ghazanfari_f,
12/19/2019,
4:14 PM
*/
package com.nicico.training.controller.util;

import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.core.SecurityUtil;
import com.nicico.training.model.Category;
import com.nicico.training.model.Subcategory;
import com.nicico.training.repository.CategoryDAO;
import com.nicico.training.repository.SubcategoryDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.util.MultiValueMap;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Set;

@Component
@RequiredArgsConstructor
public class CriteriaUtil {

    private final CategoryDAO categoryDAO;
    private final SubcategoryDAO subcategoryDAO;

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

    public SearchDTO.CriteriaRq addPermissionToCriteria(String objectType, String fieldName) {
        Long userId = SecurityUtil.getUserId();
        List<Long> ids = new ArrayList<>();

        switch (objectType) {
            case "Category" -> ids = categoryDAO.findAllByUserId(userId).stream().map(Category::getId).toList();
            case "SubCategory" -> ids = subcategoryDAO.findAllByUserId(SecurityUtil.getUserId()).stream().map(Subcategory::getId).toList();
        }

        SearchDTO.CriteriaRq criteria1 = createCriteria(EOperator.inSet, fieldName, ids);
        SearchDTO.CriteriaRq criteria2 = createCriteria(EOperator.isNull, fieldName, ids);

        List<SearchDTO.CriteriaRq> criteriaRqs = new ArrayList<>();
        criteriaRqs.add(criteria1);
        criteriaRqs.add(criteria2);

        SearchDTO.CriteriaRq result = addCriteria(criteriaRqs, EOperator.or);

        return result;

    }

}
