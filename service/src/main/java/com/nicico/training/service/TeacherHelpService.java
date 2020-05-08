package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.*;
import com.nicico.training.repository.*;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Service
@RequiredArgsConstructor
public class TeacherHelpService implements ITeacherHelpService {

    private final EmploymentHistoryDAO employmentHistoryDAO;
    private final TeachingHistoryDAO teachingHistoryDAO;
    private final TeacherCertificationDAO teacherCertificationDAO;
    private final PublicationDAO publicationDAO;
    private final ForeignLangKnowledgeDAO foreignLangKnowledgeDAO;
    private final ModelMapper modelMapper;

    @Transactional(readOnly = true)
    public SearchDTO.SearchRs<EmploymentHistoryDTO.Info> searchEmploymentHistories(SearchDTO.SearchRq request, Long teacherId) {
        request = (request != null) ? request : new SearchDTO.SearchRq();
        List<SearchDTO.CriteriaRq> list = new ArrayList<>();
        request.setDistinct(true);
        if (teacherId != null) {
            list.add(makeNewCriteria("teacherId", teacherId, EOperator.equals, null));
            SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, list);
            if (request.getCriteria() != null) {
                if (request.getCriteria().getCriteria() != null)
                    request.getCriteria().getCriteria().add(criteriaRq);
                else
                    request.getCriteria().setCriteria(list);
            } else
                request.setCriteria(criteriaRq);
        }

        for (SearchDTO.CriteriaRq criteriaRq : request.getCriteria().getCriteria()) {
            if (criteriaRq.getFieldName() != null) {
                if (criteriaRq.getFieldName().equalsIgnoreCase("subCategoriesIds"))
                    criteriaRq.setFieldName("subCategories");
                if (criteriaRq.getFieldName().equalsIgnoreCase("categoriesIds"))
                    criteriaRq.setFieldName("categories");
                if (criteriaRq.getFieldName().equalsIgnoreCase("persianStartDate"))
                    criteriaRq.setFieldName("startDate");
                if (criteriaRq.getFieldName().equalsIgnoreCase("persianEndDate"))
                    criteriaRq.setFieldName("endDate");
            }
        }
        return SearchUtil.search(employmentHistoryDAO, request, employmentHistory -> modelMapper.map(employmentHistory, EmploymentHistoryDTO.Info.class));
    }

    @Override
    @Transactional
    public List<EmploymentHistoryDTO.Info> getEmploymentHistories(Long teacherId) {
        SearchDTO.SearchRq searchRq_employmentHistories = new SearchDTO.SearchRq();
        SearchDTO.SearchRs<EmploymentHistoryDTO.Info> searchRs_employmentHistories = searchEmploymentHistories(searchRq_employmentHistories, teacherId);
        return searchRs_employmentHistories.getList();
    }

    @Transactional(readOnly = true)
    public SearchDTO.SearchRs<TeachingHistoryDTO.Info> searchTeachingHistories(SearchDTO.SearchRq request, Long teacherId) {
        request = (request != null) ? request : new SearchDTO.SearchRq();
        List<SearchDTO.CriteriaRq> list = new ArrayList<>();
        request.setDistinct(true);
        if (teacherId != null) {
            list.add(makeNewCriteria("teacherId", teacherId, EOperator.equals, null));
            SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, list);
            if (request.getCriteria() != null) {
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
                if (criteriaRq.getFieldName().equalsIgnoreCase("persianStartDate"))
                    criteriaRq.setFieldName("startDate");
                if (criteriaRq.getFieldName().equalsIgnoreCase("persianEndDate"))
                    criteriaRq.setFieldName("endDate");
            }
        }
        return SearchUtil.search(teachingHistoryDAO, request, teachingHistory -> modelMapper.map(teachingHistory, TeachingHistoryDTO.Info.class));
    }

    @Override
    @Transactional
    public List<TeachingHistoryDTO.Info> getTeachingHistories(Long teacherId) {
        SearchDTO.SearchRq searchRq_teachingHistories = new SearchDTO.SearchRq();
        SearchDTO.SearchRs<TeachingHistoryDTO.Info> searchRs_teachingHistories = searchTeachingHistories(searchRq_teachingHistories,teacherId);
        return searchRs_teachingHistories.getList();
    }

    @Transactional(readOnly = true)
    public SearchDTO.SearchRs<TeacherCertificationDTO.Info> searchTeacherCertification(SearchDTO.SearchRq request, Long teacherId) {
        request = (request != null) ? request : new SearchDTO.SearchRq();
        List<SearchDTO.CriteriaRq> list = new ArrayList<>();
        request.setDistinct(true);
        if (teacherId != null) {
            list.add(makeNewCriteria("teacherId", teacherId, EOperator.equals, null));
            SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, list);
            if (request.getCriteria() != null) {
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
                if (criteriaRq.getFieldName().equalsIgnoreCase("persianStartDate"))
                    criteriaRq.setFieldName("startDate");
                if (criteriaRq.getFieldName().equalsIgnoreCase("persianEndDate"))
                    criteriaRq.setFieldName("endDate");
            }
        }
        return SearchUtil.search(teacherCertificationDAO, request, teacherCertification -> modelMapper.map(teacherCertification, TeacherCertificationDTO.Info.class));
    }

    @Override
    @Transactional
    public List<TeacherCertificationDTO.Info> getTeacherCertifications(Long teacherId) {
        SearchDTO.SearchRq searchRq_teacherCertifications = new SearchDTO.SearchRq();
        SearchDTO.SearchRs<TeacherCertificationDTO.Info> searchRs_teacherCertifications = searchTeacherCertification(searchRq_teacherCertifications,teacherId);
        return searchRs_teacherCertifications.getList();
    }

    @Transactional(readOnly = true)
    public SearchDTO.SearchRs<PublicationDTO.Info> searchPublication(SearchDTO.SearchRq request, Long teacherId) {
        request = (request != null) ? request : new SearchDTO.SearchRq();
        List<SearchDTO.CriteriaRq> list = new ArrayList<>();
        request.setDistinct(true);
        if (teacherId != null) {
            list.add(makeNewCriteria("teacherId", teacherId, EOperator.equals, null));
            SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, list);
            if (request.getCriteria() != null) {
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


    @Override
    @Transactional
    public List<PublicationDTO.Info> getPublications(Long teacherId) {
        SearchDTO.SearchRq searchRq_publications = new SearchDTO.SearchRq();
        SearchDTO.SearchRs<PublicationDTO.Info> searchRs_publications = searchPublication(searchRq_publications,teacherId);
        return searchRs_publications.getList();
    }

    @Transactional(readOnly = true)
    public SearchDTO.SearchRs<ForeignLangKnowledgeDTO.Info> searchForeignLang(SearchDTO.SearchRq request, Long teacherId) {
        request = (request != null) ? request : new SearchDTO.SearchRq();
        List<SearchDTO.CriteriaRq> list = new ArrayList<>();
        if (teacherId != null) {
            list.add(makeNewCriteria("teacherId", teacherId, EOperator.equals, null));
            SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, list);
            if (request.getCriteria() != null) {
                if (request.getCriteria().getCriteria() != null)
                    request.getCriteria().getCriteria().add(criteriaRq);
                else
                    request.getCriteria().setCriteria(list);
            } else
                request.setCriteria(criteriaRq);
        }
        return SearchUtil.search(foreignLangKnowledgeDAO, request, foreignLangKnowledge -> modelMapper.map(foreignLangKnowledge, ForeignLangKnowledgeDTO.Info.class));
    }

    @Override
    @Transactional
    public List<ForeignLangKnowledgeDTO.Info> getForeignLangKnowledges(Long teacherId) {
        SearchDTO.SearchRq searchRq_foreignLangKnowledges  = new SearchDTO.SearchRq();
        SearchDTO.SearchRs<ForeignLangKnowledgeDTO.Info> searchRs_foreignLangKnowledges  = searchForeignLang(searchRq_foreignLangKnowledges ,teacherId);
        return searchRs_foreignLangKnowledges.getList();
    }






}
