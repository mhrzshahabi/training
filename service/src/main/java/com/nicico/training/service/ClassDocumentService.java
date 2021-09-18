package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.ClassDocumentDTO;
import com.nicico.training.iservice.IClassDocumentService;
import com.nicico.training.model.ClassDocument;
import com.nicico.training.repository.ClassDocumentDAO;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ClassDocumentService implements IClassDocumentService {

    private final ClassDocumentDAO classDocumentDAO;
    private final ModelMapper modelMapper;

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<ClassDocumentDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(classDocumentDAO, request, classDocument -> modelMapper.map(classDocument, ClassDocumentDTO.Info.class));
    }

    @Transactional
    @Override
    public ClassDocumentDTO.Info create(ClassDocumentDTO.Create request, HttpServletResponse response) {
        final ClassDocument institute = modelMapper.map(request, ClassDocument.class);

        try {
            return modelMapper.map(classDocumentDAO.saveAndFlush(institute), ClassDocumentDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.InvalidData);
        }
    }

    @Transactional
    @Override
    public ClassDocumentDTO.Info update(Long id, ClassDocumentDTO.Update request, HttpServletResponse response) {
        final ClassDocument classDocument = getClassDocument(id);
        ClassDocument updating = new ClassDocument();
        modelMapper.map(classDocument, updating);
        modelMapper.map(request, updating);
        try {
            return modelMapper.map(classDocumentDAO.saveAndFlush(updating), ClassDocumentDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional(readOnly = true)
    @Override
    public ClassDocument getClassDocument(Long id) {
        final Optional<ClassDocument> gById = classDocumentDAO.findById(id);
        return gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
    }

    @Transactional
    @Override
    public void delete(Long id) {
        try {
            classDocumentDAO.deleteById(id);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }

    @Transactional
    @Override
    public Boolean checkLetterNum(Long classId, String letterNum) {
        List<String> letterNumList = classDocumentDAO.findAllLetterNumByClassId(classId);
        return !letterNumList.contains(letterNum);
    }


}
