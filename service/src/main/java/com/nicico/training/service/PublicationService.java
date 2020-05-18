package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.PublicationDTO;
import com.nicico.training.iservice.IPublicationService;
import com.nicico.training.iservice.ITeacherService;
import com.nicico.training.model.Publication;
import com.nicico.training.model.Teacher;
import com.nicico.training.repository.PublicationDAO;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class PublicationService implements IPublicationService {

    private final ModelMapper modelMapper;
    private final PublicationDAO publicationDAO;
    private final ITeacherService teacherService;

    @Transactional(readOnly = true)
    @Override
    public PublicationDTO.Info get(Long id) {
        return modelMapper.map(getPublication(id), PublicationDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public Publication getPublication(Long id) {
        final Optional<Publication> optionalPublication = publicationDAO.findById(id);
        return optionalPublication.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
    }

    @Transactional
    @Override
    public void deletePublication(Long teacherId, Long publicationId) {
        final Teacher teacher = teacherService.getTeacher(teacherId);
        final PublicationDTO.Info publication = get(publicationId);
        try {
            teacher.getPublications().remove(modelMapper.map(publication, Publication.class));
            publication.setTeacherId(null);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }

    @Transactional
    @Override
    public void addPublication(PublicationDTO.Create request, Long teacherId) {
        final Teacher teacher = teacherService.getTeacher(teacherId);
        Publication publication = new Publication();
        modelMapper.map(request, publication);
        try {
            teacher.getPublications().add(publication);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public PublicationDTO.Info update(Long id, PublicationDTO.Update request) {
        final Publication publication = getPublication(id);
        publication.getCategories().clear();
        publication.getSubCategories().clear();
        Publication updating = new Publication();
        modelMapper.map(publication, updating);
        modelMapper.map(request, updating);
        try {
            return save(updating);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }


    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<PublicationDTO.Info> search(SearchDTO.SearchRq request, Long teacherId) {
        request = (request != null) ? request : new SearchDTO.SearchRq();
        List<SearchDTO.CriteriaRq> list = new ArrayList<>();
        request.setDistinct(true);
        if (teacherId != null) {
            list.add(makeNewCriteria("teacherId", teacherId, EOperator.equals, null));
            SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, list);
            if (request.getCriteria() != null) {
                for (SearchDTO.CriteriaRq o : request.getCriteria().getCriteria()) {
                    if(o.getFieldName().equalsIgnoreCase("categories"))
                        o.setValue(Long.parseLong(o.getValue().get(0)+""));
                    if(o.getFieldName().equalsIgnoreCase("subCategories"))
                        o.setValue(Long.parseLong(o.getValue().get(0)+""));
                }
                if (request.getCriteria().getCriteria() != null)
                    request.getCriteria().getCriteria().add(criteriaRq);
                else
                    request.getCriteria().setCriteria(list);
            } else
                request.setCriteria(criteriaRq);
        }
        for (SearchDTO.CriteriaRq  criteriaRq : request.getCriteria().getCriteria()) {
            if(criteriaRq.getFieldName() != null) {
                if (criteriaRq.getFieldName().equalsIgnoreCase("subCategoriesIds"))
                    criteriaRq.setFieldName("subCategories");
                if (criteriaRq.getFieldName().equalsIgnoreCase("categoriesIds"))
                    criteriaRq.setFieldName("categories");
                if (criteriaRq.getFieldName().equalsIgnoreCase("persianPublicationDate"))
                    criteriaRq.setFieldName("publicationDate");
            }
        }
        return SearchUtil.search(publicationDAO, request, publication -> modelMapper.map(publication, PublicationDTO.Info.class));
    }

    private PublicationDTO.Info save(Publication publication) {
        final Publication saved = publicationDAO.saveAndFlush(publication);
        return modelMapper.map(saved, PublicationDTO.Info.class);
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
