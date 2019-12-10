package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.iservice.IBaseService;
import com.nicico.training.repository.BaseDAO;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import java.io.Serializable;
import java.lang.reflect.ParameterizedType;
import java.util.List;

@Transactional
public abstract class BaseService<E, ID extends Serializable, INFO, CREATE, UPDATE, DELETE extends Serializable, DAO extends BaseDAO<E, ID>> implements IBaseService<E, ID, INFO, CREATE, UPDATE, DELETE> {

    @Autowired
    protected ModelMapper modelMapper;
    DAO dao;

    private Class<INFO> infoClassType;
    private Class<CREATE> createClassType;
    private Class<UPDATE> updateClassType;
    private Class<DELETE> deleteClassType;

    {
        infoClassType = (Class<INFO>)
                ((ParameterizedType) getClass().getGenericSuperclass())
                        .getActualTypeArguments()[2];

        createClassType = (Class<CREATE>)
                ((ParameterizedType) getClass().getGenericSuperclass())
                        .getActualTypeArguments()[3];

        updateClassType = (Class<UPDATE>)
                ((ParameterizedType) getClass().getGenericSuperclass())
                        .getActualTypeArguments()[4];

        deleteClassType = (Class<DELETE>)
                ((ParameterizedType) getClass().getGenericSuperclass())
                        .getActualTypeArguments()[5];
    }

    @Override
    @Transactional(readOnly = true)
    public List<INFO> list() {
        return modelMapper.map(dao.findAll(), new TypeToken<List<INFO>>() {
        }.getType());
    }

    @Override
    @Transactional(readOnly = true)
    public SearchDTO.SearchRs<INFO> search(SearchDTO.SearchRq rq) {
        return SearchUtil.search(dao, rq, e -> modelMapper.map(e, infoClassType));
    }

    @Override
    @Transactional(readOnly = true)
    public TotalResponse<INFO> search(NICICOCriteria request) {
        return SearchUtil.search(dao, request, e -> modelMapper.map(e, infoClassType));
    }
}



