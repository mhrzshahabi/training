package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.iservice.IBaseService;
import com.nicico.training.repository.BaseDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import java.io.Serializable;
import java.lang.reflect.ParameterizedType;
import java.util.List;
import java.util.Optional;

@Transactional
@RequiredArgsConstructor
public abstract class BaseService<E, ID extends Serializable, INFO, CREATE, UPDATE, DELETE, DAO extends BaseDAO<E, ID>> implements IBaseService<E, ID, INFO, CREATE, UPDATE, DELETE> {

    @Autowired
    protected ModelMapper modelMapper;
    protected DAO dao;
    protected E entity;

    private Class<E> entityType;
    private Class<INFO> infoType;
    private Class<CREATE> createType;
    private Class<UPDATE> updateType;
    private Class<DELETE> deleteType;

    {
        entityType = (Class<E>)
                ((ParameterizedType) getClass().getGenericSuperclass())
                        .getActualTypeArguments()[0];

        infoType = (Class<INFO>)
                ((ParameterizedType) getClass().getGenericSuperclass())
                        .getActualTypeArguments()[2];

        createType = (Class<CREATE>)
                ((ParameterizedType) getClass().getGenericSuperclass())
                        .getActualTypeArguments()[3];

        updateType = (Class<UPDATE>)
                ((ParameterizedType) getClass().getGenericSuperclass())
                        .getActualTypeArguments()[4];

        deleteType = (Class<DELETE>)
                ((ParameterizedType) getClass().getGenericSuperclass())
                        .getActualTypeArguments()[5];
    }

    BaseService( E entity, DAO dao) {
        this.entity = entity;
        this.dao = dao;
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
        return SearchUtil.search(dao, rq, e -> modelMapper.map(e, infoType));
    }

    @Override
    @Transactional(readOnly = true)
    public TotalResponse<INFO> search(NICICOCriteria rq) {
        return SearchUtil.search(dao, rq, e -> modelMapper.map(e, infoType));
    }

    @Override
    @Transactional
    public INFO create(CREATE rq) {
        final E entity = modelMapper.map(rq, entityType);
        return modelMapper.map(dao.save(entity), infoType);
    }

    @Override
    @Transactional
    public INFO update(ID id, UPDATE rq) {
        final Optional<E> optional = dao.findById(id);
        final E currentEntity = optional.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

        modelMapper.map(currentEntity, entity);
        modelMapper.map(rq, entity);
        return modelMapper.map(dao.save(entity), infoType);
    }

    @Override
    @Transactional
    public INFO delete(ID id) {
        final Optional<E> optional = dao.findById(id);
        final E entity = optional.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        dao.deleteById(id);
        return modelMapper.map(entity, infoType);
    }
}
