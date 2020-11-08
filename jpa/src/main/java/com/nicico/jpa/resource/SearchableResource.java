package com.nicico.jpa.resource;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.domain.criteria.NICICOPageable;
import com.nicico.copper.common.domain.criteria.NICICOSpecification;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.jpa.model.repository.NicicoRepository;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;

@RestController
public abstract class SearchableResource<T, V> {

    @Autowired
    private NicicoRepository<T> repository;
    @Autowired
    private ObjectMapper objectMapper;

    public abstract V targetMapping(Page<T> searchResult, int startRow, int endRow);

    public abstract SearchDTO.CriteriaRq getPermission(SearchDTO.SearchRq request);

    public abstract SearchDTO.SearchRq mappedValues(SearchDTO.SearchRq request);


    @GetMapping(value = "/search", produces = "application/json")
    public ResponseEntity<V> search(@RequestParam(value = "_startRow", required = false, defaultValue = "0") Integer startRow,
                                    @RequestParam(value = "_endRow", required = false, defaultValue = "1") Integer endRow,
                                    @RequestParam(value = "_constructor", required = false) String constructor,
                                    @RequestParam(value = "operator", required = false) String operator,
                                    @RequestParam(value = "criteria", required = false) String criteria,
                                    @RequestParam(value = "id", required = false) Long id,
                                    @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        SearchDTO.CriteriaRq criteriaRq;

        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
            criteria = "[" + criteria + "]";
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.valueOf(operator))
                    .setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
                    }));
            request.setCriteria(criteriaRq);

        }
        if (StringUtils.isNotEmpty(sortBy)) {
            request.setSortBy(sortBy);
        }
        if (id != null) {
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.equals)
                    .setFieldName("id")
                    .setValue(id);
            request.setCriteria(criteriaRq);
            startRow = 0;
            endRow = 1;
        }
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);
        if (getPermission(request) != null) {
            request.setCriteria(getPermission(request));
        }
        if (request.getCriteria() != null && mappedValues(request) != null) {
            request = mappedValues(request);
        }
        Page<T> result = repository.findAll(NICICOSpecification.of(request), NICICOPageable.of(request));

        return new ResponseEntity<>(targetMapping(result, startRow, endRow), HttpStatus.OK);
    }

}
