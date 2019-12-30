package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.BehavioralGoalDTO;
import com.nicico.training.dto.CheckListItemDTO;
import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.dto.JobDTO;
import com.nicico.training.iservice.IBehavioralGoalService;
import com.nicico.training.model.BehavioralGoal;
import com.nicico.training.model.ClassStudent;
import com.nicico.training.repository.BehavioralGoalsDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class BehavioralGoalService implements IBehavioralGoalService {
private final BehavioralGoalsDAO behavioralGoalsDAO;
 private final ModelMapper mapper;

  @Transactional(readOnly = true)
    @Override
    public BehavioralGoalDTO.Info get(Long id) {
        final Optional<BehavioralGoal> optionalBehavioralGoal = behavioralGoalsDAO.findById(id);
        final BehavioralGoal behavioralGoal = optionalBehavioralGoal.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CheckListNotFound));
        return mapper.map(behavioralGoal, BehavioralGoalDTO.Info.class);
    }

    @Transactional
    @Override
    public List<BehavioralGoalDTO.Info> list() {
        List<BehavioralGoal> behavioralGoalList = behavioralGoalsDAO.findAll();
        return mapper.map(behavioralGoalList, new TypeToken<List<BehavioralGoalDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public BehavioralGoalDTO.Info create(BehavioralGoalDTO.Create request) {
        BehavioralGoal behavioralGoal = mapper.map(request, BehavioralGoal.class);
        return mapper.map(behavioralGoalsDAO.saveAndFlush(behavioralGoal), BehavioralGoalDTO.Info.class);
    }

    @Transactional
    @Override
    public BehavioralGoalDTO.Info update(Long id, BehavioralGoalDTO.Update request) {
        Optional<BehavioralGoal> optionalBehavioralGoal = behavioralGoalsDAO.findById(id);
        BehavioralGoal currentCheckList = optionalBehavioralGoal.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CheckListNotFound));
        BehavioralGoal behavioralGoal = new BehavioralGoal();
        mapper.map(currentCheckList, behavioralGoal);
        mapper.map(request, behavioralGoal);
        return mapper.map(behavioralGoalsDAO.saveAndFlush(behavioralGoal), BehavioralGoalDTO.Info.class);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        behavioralGoalsDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(BehavioralGoalDTO.Delete request) {
        final List<BehavioralGoal> behavioralGoalList = behavioralGoalsDAO.findAllById(request.getIds());
        behavioralGoalsDAO.deleteAll(behavioralGoalList);
    }

    @Transactional(readOnly = true)
    @Override
    public TotalResponse<BehavioralGoalDTO.Info> search(NICICOCriteria request) {
        return SearchUtil.search(behavioralGoalsDAO, request, behavioralGoal -> mapper.map(behavioralGoal,BehavioralGoalDTO.Info.class));
    }



    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<BehavioralGoalDTO.Info> search(SearchDTO.SearchRq request, Long goalId) {
        request = (request != null) ? request : new SearchDTO.SearchRq();
        List<SearchDTO.CriteriaRq> list = new ArrayList<>();
        if (goalId != null) {
            list.add(makeNewCriteria("goalId", goalId, EOperator.equals, null));
            SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, list);
            if (request.getCriteria() != null) {
                if (request.getCriteria().getCriteria() != null)
                    request.getCriteria().getCriteria().add(criteriaRq);
                else
                    request.getCriteria().setCriteria(list);
            } else
                request.setCriteria(criteriaRq);
        }
        return SearchUtil.search(behavioralGoalsDAO, request, classStudent -> mapper.map(classStudent, BehavioralGoalDTO.Info.class));
    }

    private SearchDTO.CriteriaRq makeNewCriteria(String fieldName, Object value, EOperator operator, List<SearchDTO.CriteriaRq> criteriaRqList) {
        SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();
        criteriaRq.setOperator(operator);
        criteriaRq.setFieldName(fieldName);
        criteriaRq.setValue(value);
        criteriaRq.setCriteria(criteriaRqList);
        return criteriaRq;
    }
}
