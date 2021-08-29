package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.domain.criteria.NICICOPageable;
import com.nicico.copper.common.domain.criteria.NICICOSpecification;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.core.SecurityUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.iservice.IBaseService;
import com.nicico.training.repository.BaseDAO;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.Page;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.transaction.annotation.Transactional;

import java.io.Serializable;
import java.lang.reflect.Field;
import java.lang.reflect.ParameterizedType;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.function.Function;

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

    BaseService(E entity, DAO dao) {
        this.entity = entity;
        this.dao = dao;
    }

    @Override
    @Transactional(readOnly = true)
    public List<INFO> list() {
        return mapEntityToInfo(dao.findAll());
    }

    @Override
    @Transactional(readOnly = true)
    public SearchDTO.SearchRs<INFO> search(SearchDTO.SearchRq rq) {
        return SearchUtil.search(dao, rq, e -> modelMapper.map(e, infoType));
    }

    public static <E, INFO, DAO extends JpaSpecificationExecutor<E>> SearchDTO.SearchRs<INFO> optimizedSearch(DAO dao, Function<E, INFO> converter, SearchDTO.SearchRq rq) throws NoSuchFieldException, IllegalAccessException {

        SearchDTO.SearchRs<INFO> searchRs = null;

        if (rq.getStartIndex() == null) {
            searchRs = SearchUtil.search(dao, rq, converter);
        } else {
            Page<E> all = dao.findAll(NICICOSpecification.of(rq), NICICOPageable.of(rq));
            List<E> list = all.getContent();

            Long totalCount = all.getTotalElements();


            if (totalCount == 0) {

                searchRs = new SearchDTO.SearchRs<>();
                searchRs.setList(new ArrayList<INFO>());

            } else {
                List<Long> ids = new ArrayList<>();
                int len = list.size();
                Field field = null;

                for (int i = 0; i < len; i++) {

                    field = list.get(i).getClass().getDeclaredField("id");

                    field.setAccessible(true);

                    Object value = field.get(list.get(i));
                    ids.add((Long) value);
                }

                rq.setCriteria(makeNewCriteria("", null, EOperator.or, null));
                List<SearchDTO.CriteriaRq> criteriaRqList = new ArrayList<>();
                SearchDTO.CriteriaRq tmpcriteria = null;
                int page = 0;

                while (page * 1000 < ids.size()) {
                    page++;
                    criteriaRqList.add(makeNewCriteria("id", ids.subList((page - 1) * 1000, Math.min((page * 1000), ids.size())), EOperator.inSet, null));

                }

                rq.setCriteria(makeNewCriteria("", null, EOperator.or, criteriaRqList));
                rq.setStartIndex(null);

                searchRs = SearchUtil.search(dao, rq, converter);
            }

            searchRs.setTotalCount(totalCount);
        }

        return searchRs;
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
        try {
            return modelMapper.map(dao.save(entity), infoType);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Override
    @Transactional
    public INFO update(ID id, UPDATE rq) {
        final Optional<E> optional = dao.findById(id);
        final E currentEntity = optional.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        modelMapper.map(currentEntity, entity);
        modelMapper.map(rq, entity);
        try {
            return modelMapper.map(dao.save(entity), infoType);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Override
    @Transactional
    public INFO delete(ID id) {
        final Optional<E> optional = dao.findById(id);
        final E entity = optional.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        try {
            dao.deleteById(id);
            return modelMapper.map(entity, infoType);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }

    @Override
    @Transactional
    public Boolean isExist(ID id) {
        final Optional<E> optional = dao.findById(id);
        return optional.isPresent();
    }

    @Override
    @Transactional
    public E get(ID id) {
        final Optional<E> optional = dao.findById(id);
        return optional.orElse(null);
    }

    @Override
    @Transactional(readOnly = true)
    public List<INFO> mapEntityToInfo(List<E> eList) {
        List<INFO> infoList = new ArrayList<>();
        Optional.ofNullable(eList).ifPresent(entities -> entities.forEach(entity -> infoList.add(modelMapper.map(entity, infoType))));
        return infoList;
    }

    public static SearchDTO.CriteriaRq makeNewCriteria(String fieldName, Object value, EOperator operator, List<SearchDTO.CriteriaRq> criteriaRqList) {
        SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();
        criteriaRq.setOperator(operator);
        criteriaRq.setFieldName(fieldName);
        criteriaRq.setValue(value);
        criteriaRq.setCriteria(criteriaRqList);
        return criteriaRq;
    }

    public static void setCriteria(SearchDTO.SearchRq request, SearchDTO.CriteriaRq criteria) {
        request.setDistinct(true);
        if (request.getCriteria() == null) {
            request.setCriteria(criteria);
            return;
        }
        SearchDTO.CriteriaRq mainCriteria = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        mainCriteria.getCriteria().add(criteria);
        mainCriteria.getCriteria().add(request.getCriteria());
        mainCriteria.setStart(request.getCriteria().getStart());
        mainCriteria.setEnd(request.getCriteria().getEnd());
        request.setCriteria(mainCriteria);
    }

    public static void setCriteriaToNotSearchDeleted(SearchDTO.SearchRq request) {
        SearchDTO.CriteriaRq criteria = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        criteria.getCriteria().add(makeNewCriteria("deleted", null, EOperator.isNull, null));
        if (request.getCriteria() != null)
            criteria.getCriteria().add(request.getCriteria());
        request.setCriteria(criteria);
    }

    public static void combineCriteria(SearchDTO.SearchRq request,SearchDTO.CriteriaRq addCriteria) {
        SearchDTO.CriteriaRq criteria = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        criteria.getCriteria().add(addCriteria);
        if (request.getCriteria() != null)
            criteria.getCriteria().add(request.getCriteria());
        request.setCriteria(criteria);
    }


    public static void combineRoleToCriteriaComplex(SearchDTO.SearchRq request) {
        Set<String> authorities = SecurityUtil.getAuthorities();
        SearchDTO.CriteriaRq criteria = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        SearchDTO.CriteriaRq icCriteria = makeNewCriteria(null, null, EOperator.or, new ArrayList<>());
        if (authorities.contains("tehranManagementAccess")){
            SearchDTO.CriteriaRq tempReq = makeNewCriteria("code", "110000000000", EOperator.equals, null);
            icCriteria.getCriteria().add(tempReq);
        }
        if (authorities.contains("tehranRetirementAccess")){
            SearchDTO.CriteriaRq tempReq = makeNewCriteria("code", "111000000000", EOperator.equals, null);
            icCriteria.getCriteria().add(tempReq);
        }
        if (authorities.contains("sarcheshmeAccess")){
            SearchDTO.CriteriaRq tempReq = makeNewCriteria("code", "121000000000", EOperator.equals, null);
            icCriteria.getCriteria().add(tempReq);
        }
        if (authorities.contains("shahreBabakAccess")){
            SearchDTO.CriteriaRq tempReq = makeNewCriteria("code", "122000000000", EOperator.equals, null);
            icCriteria.getCriteria().add(tempReq);
        }
        if (authorities.contains("azarbayejanAccess")){
            SearchDTO.CriteriaRq tempReq = makeNewCriteria("code", "130000000000", EOperator.equals, null);
            icCriteria.getCriteria().add(tempReq);
        }
        if (icCriteria.getCriteria().isEmpty()){
            SearchDTO.CriteriaRq tempReq = makeNewCriteria("code", "123", EOperator.equals, null);
            icCriteria.getCriteria().add(tempReq);
        }
        criteria.getCriteria().add(icCriteria);
        if (request.getCriteria() != null)
            criteria.getCriteria().add(request.getCriteria());
        request.setCriteria(criteria);
    }

}
