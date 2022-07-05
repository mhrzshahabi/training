package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.OperationalChartDTO;
import com.nicico.training.iservice.IOperationalChartService;
import com.nicico.training.mapper.operationalChart.OperationalChartMapper;
import com.nicico.training.model.OperationalChart;
import com.nicico.training.repository.OperationalChartDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;


@Service
@RequiredArgsConstructor
public class OperationalChartService implements IOperationalChartService {
     private final OperationalChartDAO operationalChartDAO;
     private final OperationalChartMapper mapper;
    @Autowired
    private MessageSource messageSource;

    @Transactional(readOnly = true)
    @Override
    public OperationalChartDTO.Info get(Long id) {
        final Optional<OperationalChart> gById = operationalChartDAO.findById(id);
        final OperationalChart operationalChart = gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.OperationalChartNotFound));
        return mapper.toInfoDTO(operationalChart);
    }

    @Transactional(readOnly = true)
    @Override
    public List<OperationalChartDTO.Info> list() {
        final List<OperationalChart> gAll = operationalChartDAO.findAll();
        return mapper.toInfoDTOList(gAll);

    }

    @Transactional
    @Override
    public OperationalChartDTO.Info create(OperationalChartDTO.Create request)  {
        final OperationalChart operationalChart = mapper.toOperationalChart(request);

        final List<OperationalChart> allOperationalChart = operationalChartDAO.findAll();

        Set<OperationalChart> set = new HashSet<>();
        allOperationalChart.forEach(one -> {
                    if (one.getNationalCode().contains(operationalChart.getNationalCode())) {
                        set.add(one);
                    }
                }
        );

        if (set.stream().toList().size() != 0) {
            throw new TrainingException(TrainingException.ErrorType.OperationalChartIsDuplicated, messageSource.getMessage("exception.duplicate.information", null, LocaleContextHolder.getLocale()));
        }
        return save(operationalChart);

    }

    @Override
    public OperationalChartDTO.Info addChild(Long parentId, Long childId)  {
        Optional<OperationalChart> findOperationalParent=  operationalChartDAO.findById(parentId);
        Optional<OperationalChart> findOperationalChild=  operationalChartDAO.findById(childId);
        Optional<OperationalChart> operationalParent= Optional.ofNullable(findOperationalParent.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound)));
        Optional<OperationalChart> operationalChild= Optional.ofNullable(findOperationalChild.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound)));

        if (!operationalParent.isPresent() || !operationalChild.isPresent()){
            throw new TrainingException(TrainingException.ErrorType.NotFound, messageSource.getMessage("exception.record.not−found", null, LocaleContextHolder.getLocale()));
        }else {
            OperationalChart parent = operationalParent.get();
            OperationalChart child = operationalChild.get();
            if(parent.getParentId() == child.getId() || parent.getId() ==child.getId()) {
                throw new TrainingException(TrainingException.ErrorType. Forbidden, messageSource.getMessage("exception.forbidden.operation", null, LocaleContextHolder.getLocale()));
                } else {

                    Set<OperationalChart> lastChilds = new HashSet<>(operationalChartDAO.findAllByParentId(parentId));
                    lastChilds.add(child);
                    parent.setOperationalChartParentChild(lastChilds.stream().toList());
                    save(parent);
                    Optional<OperationalChart> savedParent = operationalChartDAO.findById(parent.getId());

                    child.setParentId(savedParent.get().getId());
                    OperationalChartDTO.Info savedChild = save(child);
                    return savedChild;
                }
        }

    }

    @Transactional
    @Override
    public OperationalChartDTO.Info update(Long id, OperationalChartDTO.Update request) {
        final Optional<OperationalChart> cById = operationalChartDAO.findById(id);
        final OperationalChart operationalChart = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));

        OperationalChart toUpdate= mapper.toUpdate(operationalChart,request);

      return save(toUpdate) ;
    }

    @Transactional
    @Override
    public OperationalChartDTO.Info updateParent(Long id,Long newParentId) {
        final Optional<OperationalChart> cById = operationalChartDAO.findById(id);
        final OperationalChart operationalChart = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));

        //remove from old parent
        Optional<OperationalChart> findOperationalOldParent=  operationalChartDAO.findById(operationalChart.getParentId());
        Optional<OperationalChart> operationalOldParent= Optional.ofNullable(findOperationalOldParent.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound)));
        if (operationalOldParent.isPresent()) {
            OperationalChart OldParent = operationalOldParent.get();
            OldParent.getOperationalChartParentChild().remove(operationalChart);
            save(OldParent);
        }else{  throw new TrainingException(TrainingException.ErrorType.NotFound, messageSource.getMessage("exception.record.not−found", null, LocaleContextHolder.getLocale()));}

        //set on new parent
        Set<OperationalChart> lastChilds = new HashSet<>(operationalChartDAO.findAllByParentId(newParentId));

        lastChilds.add(operationalChart);
        Optional<OperationalChart> findOperationalNewParent=  operationalChartDAO.findById(newParentId);
        Optional<OperationalChart> operationalNewParent= Optional.ofNullable(findOperationalNewParent.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound)));
        if (operationalNewParent.isPresent()) {
            OperationalChart NewParent = operationalNewParent.get();
            NewParent.setOperationalChartParentChild(lastChilds.stream().toList());
            save(NewParent);
        }else{  throw new TrainingException(TrainingException.ErrorType.NotFound, messageSource.getMessage("exception.record.not−found", null, LocaleContextHolder.getLocale()));}

        operationalChart.setParentId(newParentId);
        OperationalChartDTO.Info savedChild = save(operationalChart);
        return savedChild;
    }

    @Transactional
    @Override
    public void delete(Long id) {
        final Optional<OperationalChart> one = operationalChartDAO.findById(id);
        final OperationalChart OperationalToDelete = one.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));

        Optional<OperationalChart> findOperationalParent=  operationalChartDAO.findById(OperationalToDelete.getParentId());
        Optional<OperationalChart> operationalParent= Optional.ofNullable(findOperationalParent.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound)));

        if (OperationalToDelete.getOperationalChartParentChild().size()==0) {
            OperationalChart parent = operationalParent.get();
            parent.getOperationalChartParentChild().remove(OperationalToDelete);
            save(parent);
            operationalChartDAO.delete(OperationalToDelete);
        }else
        {
        throw new TrainingException(TrainingException.ErrorType. OperationalChartHasChild, messageSource.getMessage("exception.forbidden.operation", null, LocaleContextHolder.getLocale()));
        }
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<OperationalChartDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(operationalChartDAO, request, operationalChart -> mapper.toInfoDTO(request));
    }

    private OperationalChartDTO.Info save(OperationalChart operationalChart) {
        final OperationalChart saved = operationalChartDAO.saveAndFlush(operationalChart);
        return mapper.toInfoDTO(saved);
    }
}
