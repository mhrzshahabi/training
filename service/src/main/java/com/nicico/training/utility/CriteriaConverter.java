package com.nicico.training.utility;

import com.nicico.copper.common.dto.search.SearchDTO;

import java.util.HashMap;
import java.util.Map;

public class CriteriaConverter {

    public static void criteria2ParamsMap(SearchDTO.CriteriaRq criteria,
                                         Map<String, Object[]> map) {
        if (criteria == null)
            return;
        if (criteria.getFieldName() == null) {
            if (criteria.getCriteria() != null && !criteria.getCriteria().isEmpty()) {
                for (int i = 0; i < criteria.getCriteria().size(); i++) {
                    criteria2ParamsMap(criteria.getCriteria().get(i),
                            map);
                }
            }
            return;
        }
        map.put(criteria.getFieldName(), criteria.getValue().toArray());
    }

    public static Boolean removeCriteriaByfieldName(SearchDTO.CriteriaRq criteria,
                                                 String name) {
        if (criteria == null)
            return false;
        if (criteria.getFieldName() == null) {
            if (criteria.getCriteria() != null && !criteria.getCriteria().isEmpty()) {
                for (int i = 0; i < criteria.getCriteria().size(); i++) {
                    if(removeCriteriaByfieldName(criteria.getCriteria().get(i), name))
                        criteria.getCriteria().remove(i);
                }
            }
            return false;
        }
        if(criteria.getFieldName().equals(name))
            return true;
        return false;
    }
}
