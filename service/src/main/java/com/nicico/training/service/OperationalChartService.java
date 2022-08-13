package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.OperationalChartDTO;
import com.nicico.training.iservice.IOperationalChartService;
import com.nicico.training.iservice.ISynonymOAUserService;
import com.nicico.training.mapper.operationalChart.OperationalChartMapper;
import com.nicico.training.model.OperationalChart;
import com.nicico.training.repository.ComplexDAO;
import com.nicico.training.repository.OperationalChartDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
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
    private final ISynonymOAUserService synonymOAUserService;
    private final ComplexDAO complexDAO;
    private final ModelMapper modelMapper;

    @Autowired
    private MessageSource messageSource;

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<OperationalChartDTO.Info> deepSearch(SearchDTO.SearchRq searchRq) throws NoSuchFieldException, IllegalAccessException {
        if (searchRq.getCriteria() != null && searchRq.getCriteria().getCriteria() != null) {
            for (SearchDTO.CriteriaRq criterion : searchRq.getCriteria().getCriteria()) {
                if (criterion.getFieldName().equals("complex")) {
                    criterion.setFieldName("complex");
                    List<Object> value = criterion.getValue();
                    Object o = value.get(0);
                    Long ComplexId = Long.valueOf(o.toString());

                    String complexTitle = complexDAO.findById(ComplexId).get().getTitle();
                    criterion.setValue(complexTitle);
                }
            }
        }

        SearchDTO.SearchRs<OperationalChartDTO.Info> searchRs = BaseService.<OperationalChart, OperationalChartDTO.Info, OperationalChartDAO>optimizedSearch(operationalChartDAO, p -> modelMapper.map(p, OperationalChartDTO.Info.class), searchRq);
        return searchRs;
    }

    @Transactional(readOnly = true)
    @Override
    public OperationalChartDTO.Info get(Long id) {
        final Optional<OperationalChart> gById = operationalChartDAO.findById(id);
        final OperationalChart operationalChart = gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.OperationalChartNotFound));
        return mapper.toInfoDTO(operationalChart);
    }

    @Transactional(readOnly = true)
    @Override
    public List<OperationalChartDTO.Info> list(Long complexId) {
        final List<OperationalChart> gAll = operationalChartDAO.findAll();

        String complexTitle = complexDAO.findById(complexId).get().getTitle();

        Set<OperationalChart> set = new HashSet<>();
        gAll.forEach(one -> {
                    if (one.getComplex().equals(complexTitle)) {
                        set.add(one);
                    }
                }
        );
        List<OperationalChart> listByComplex = set.stream().toList();
        return mapper.toInfoDTOList(listByComplex);

    }

    @Transactional
    @Override
    public OperationalChartDTO.Info create(OperationalChartDTO.Create request) {
        final OperationalChart operationalChart = mapper.toOperationalChart(request);

        String fullName = synonymOAUserService.getFullNameByUserId(request.getUserId());
        String nationalCode = synonymOAUserService.getNationalCodeByUserId(request.getUserId());

        final List<OperationalChart> allOperationalChart = operationalChartDAO.findAll();

        Set<OperationalChart> set = new HashSet<>();
        allOperationalChart.forEach(one -> {
                    if (one.getNationalCode().contains(nationalCode)) {
                        set.add(one);
                    }
                }
        );

        if (set.stream().toList().size() != 0) {
            throw new TrainingException(TrainingException.ErrorType.OperationalChartIsDuplicated, messageSource.getMessage("exception.duplicate.information", null, LocaleContextHolder.getLocale()));
        }

        operationalChart.setNationalCode(nationalCode);
        operationalChart.setUserName(fullName);

        Long ComplexId = Long.valueOf(request.getComplex());
        String complexTitle = complexDAO.findById(ComplexId).get().getTitle();
        operationalChart.setComplex(complexTitle);

        if (operationalChart.getParentId() != null) {
            Optional<OperationalChart> findOperationalParent = operationalChartDAO.findById(operationalChart.getParentId());
            Optional<OperationalChart> operationalParent = Optional.ofNullable(findOperationalParent.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound)));

            if (operationalParent.isEmpty()) {
                throw new TrainingException(TrainingException.ErrorType.NotFound, messageSource.getMessage("exception.record.not−found", null, LocaleContextHolder.getLocale()));
            } else {
                OperationalChart parent = operationalParent.get();
                OperationalChart child = operationalChart;

                if ((parent.getParentId() != null && parent.getParentId().equals(child.getId())) || parent.getId().equals(child.getId())) {  // || operationalChild.get().getParentId() !=null
                    throw new TrainingException(TrainingException.ErrorType.Forbidden, messageSource.getMessage("exception.forbidden.operation", null, LocaleContextHolder.getLocale()));
                } else {
                    Set<OperationalChart> lastChilds = new HashSet<>(operationalChartDAO.findAllByParentId(parent.getId()));
                    lastChilds.add(child);
                    parent.setOperationalChartParentChild(lastChilds.stream().toList());
                    child.setParentId(parent.getId());
                }
            }
        }

        return save(operationalChart);

    }
// to update a parent should first do removeOldParent then do addChild

    @Transactional
    @Override
    public OperationalChartDTO.Info removeOldParent(Long childId) {
        final Optional<OperationalChart> cById = operationalChartDAO.findById(childId);
        final OperationalChart operationalChart = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));

        if (operationalChart.getParentId() == null) {
            return mapper.toInfoDTO(operationalChart); // if it don't have parent,just return itself.
        }

        Optional<OperationalChart> findOperationalOldParent = operationalChartDAO.findById(operationalChart.getParentId());
        Optional<OperationalChart> operationalOldParent = Optional.ofNullable(findOperationalOldParent.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound)));

        if (operationalOldParent.isPresent()) {
            OperationalChart OldParent = operationalOldParent.get();
            OldParent.getOperationalChartParentChild().remove(operationalChart);
            operationalChart.setParentId(null);

            return mapper.toInfoDTO(operationalChart);

        } else {
            return mapper.toInfoDTO(operationalChart); // if it don't have parent,just return itself.
//            throw new TrainingException(TrainingException.ErrorType.NotFound, messageSource.getMessage("exception.record.not−found", null, LocaleContextHolder.getLocale()));
        }

    }

    @Transactional
    @Override
    public OperationalChartDTO.Info addChild(Long parentId, Long childId) {
        Optional<OperationalChart> findOperationalParent = operationalChartDAO.findById(parentId);
        Optional<OperationalChart> findOperationalChild = operationalChartDAO.findById(childId);
        Optional<OperationalChart> operationalParent = Optional.ofNullable(findOperationalParent.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound)));
        Optional<OperationalChart> operationalChild = Optional.ofNullable(findOperationalChild.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound)));

        if (operationalParent.isEmpty() || operationalChild.isEmpty()) {
            throw new TrainingException(TrainingException.ErrorType.NotFound, messageSource.getMessage("exception.record.not−found", null, LocaleContextHolder.getLocale()));
        } else {
            OperationalChart parent = operationalParent.get();
            OperationalChart child = operationalChild.get();

            if ((parent.getParentId() != null && parent.getParentId().equals(child.getId())) || parent.getId().equals(child.getId())) {  // || operationalChild.get().getParentId() !=null
                throw new TrainingException(TrainingException.ErrorType.Forbidden, messageSource.getMessage("exception.forbidden.operation", null, LocaleContextHolder.getLocale()));
            } else {
                Set<OperationalChart> lastChilds = new HashSet<>(operationalChartDAO.findAllByParentId(parentId));
                lastChilds.add(child);
                parent.setOperationalChartParentChild(lastChilds.stream().toList());
                child.setParentId(parent.getId());

                return mapper.toInfoDTO(child);

            }
        }

    }

    @Transactional
    @Override
    public OperationalChartDTO.Info update(Long id, OperationalChartDTO.Update request) {
        final Optional<OperationalChart> cById = operationalChartDAO.findById(id);
        final OperationalChart operationalChart = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));

        OperationalChart toUpdate = mapper.toUpdate(operationalChart, request);

        String fullName = synonymOAUserService.getFullNameByUserId(request.getUserId());
        String nationalCode = synonymOAUserService.getNationalCodeByUserId(request.getUserId());
        toUpdate.setNationalCode(nationalCode);
        toUpdate.setUserName(fullName);

        Long ComplexId = Long.valueOf(request.getComplex());
        String complexTitle = complexDAO.findById(ComplexId).get().getTitle();
        toUpdate.setComplex(complexTitle);

        return save(toUpdate);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        final Optional<OperationalChart> one = operationalChartDAO.findById(id);
        final OperationalChart OperationalToDelete = one.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));

        if (OperationalToDelete.getParentId() == null) {
            operationalChartDAO.delete(OperationalToDelete);
            return;
        }
        Optional<OperationalChart> findOperationalParent = operationalChartDAO.findById(OperationalToDelete.getParentId());
        Optional<OperationalChart> operationalParent = Optional.ofNullable(findOperationalParent.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound)));

        if (OperationalToDelete.getOperationalChartParentChild().size() == 0) {
            OperationalChart parent = operationalParent.get();
            parent.getOperationalChartParentChild().remove(OperationalToDelete);
            save(parent);
            operationalChartDAO.delete(OperationalToDelete);
        } else {
            throw new TrainingException(TrainingException.ErrorType.OperationalChartHasChild, messageSource.getMessage("exception.forbidden.operation", null, LocaleContextHolder.getLocale()));
        }
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<OperationalChartDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(operationalChartDAO, request, operationalChart -> mapper.toInfoDTO(operationalChart));
    }

    @Transactional
    OperationalChartDTO.Info save(OperationalChart operationalChart) {
        OperationalChart saved = operationalChartDAO.saveAndFlush(operationalChart);
        return mapper.toInfoDTO(saved);
    }
}
