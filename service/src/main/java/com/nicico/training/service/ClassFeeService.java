package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.ClassFeeDTO;
import com.nicico.training.iservice.IClassFeeService;
import com.nicico.training.mapper.ClassFee.ClassFeeMapper;
import com.nicico.training.model.ClassFee;
import com.nicico.training.model.Tclass;
import com.nicico.training.model.enums.AgreementStatus;
import com.nicico.training.model.enums.ClassFeeStatus;
import com.nicico.training.repository.ClassFeeDAO;
import com.nicico.training.repository.ComplexDAO;
import com.nicico.training.repository.TclassDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ClassFeeService implements IClassFeeService {

    private final ClassFeeDAO classFeeDAO;
    private final ComplexDAO complexDAO;
    private final TclassDAO tclassDAO;
    private final ClassFeeMapper mapper;
    private final FeeItemService feeItemService;

    @Override
    public ClassFee get(Long id) {
        return classFeeDAO.findById(id)
                .orElseThrow(() -> new TrainingException(TrainingException.ErrorType.TclassNotFound));
    }

    @Override
    public ClassFeeDTO.Info create(ClassFeeDTO.Create create) {
        ClassFee classFee = mapper.toEntity(create);
        if (classFee.getClassId() != null) {
            tclassDAO.findById(create.getClassId()).ifPresent(tclass -> classFee.setClassTitle(tclass.getTitleClass()));
        }
        classFee.setClassFeeStatus(ClassFeeStatus.REGISTERED);
        ClassFee savedClassFee = classFeeDAO.save(classFee);
        ClassFeeDTO.Info info = mapper.toInfo(savedClassFee);
        String complexTitle = complexDAO.getComplexTitleByComplexId(classFee.getComplexId());
        info.setComplexTitle(complexTitle);
        if (classFee.getClassId() != null) {
            tclassDAO.findById(classFee.getClassId()).ifPresent(tclass -> info.setClassTitle(tclass.getTitleClass()));
        }
        return info;
    }

    @Override
    public ClassFee update(ClassFeeDTO.Create update, Long id) {
        ClassFee classFee = get(id);
        ClassFee updated = mapper.update(update, classFee);
        if (update.getClassId() != null) {
            tclassDAO.findById(update.getClassId()).ifPresent(tclass -> updated.setClassTitle(tclass.getTitleClass()));
        } else {
            updated.setClassTitle(null);
        }
        return classFeeDAO.save(updated);
    }

    @Override
    public SearchDTO.SearchRs<ClassFeeDTO.Info> search(SearchDTO.SearchRq request) throws IllegalAccessException, NoSuchFieldException {
        if (request.getCriteria() != null && request.getCriteria().getCriteria() != null) {
            for (SearchDTO.CriteriaRq criterion : request.getCriteria().getCriteria()) {
                if (criterion.getFieldName() != null) {
                    if (criterion.getFieldName().equals("classFeeStatus")) {
                        if (criterion.getValue().get(0).equals("1")) {
                            criterion.setValue(ClassFeeStatus.REGISTERED);
                        } else if (criterion.getValue().get(0).equals("2")) {
                            criterion.setValue(ClassFeeStatus.PAID);
                        }
                    }
                }
            }
        }
        return SearchUtil.search(classFeeDAO, request, classFee -> {
            String complexTitle = complexDAO.getComplexTitleByComplexId(classFee.getComplexId());
            ClassFeeDTO.Info info = mapper.toInfo(classFee);
            info.setComplexTitle(complexTitle);
            if (classFee.getClassId() != null) {
                tclassDAO.findById(classFee.getClassId()).ifPresent(tclass -> info.setClassTitle(tclass.getTitleClass()));
            }
            return info;
        });
    }

    @Override
    public void delete(Long id) {
        try {
            feeItemService.deleteAllByParentId(id);
            classFeeDAO.deleteById(id);
        } catch (Exception e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }
}
