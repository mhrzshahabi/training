package com.nicico.training.service;

import com.ibm.icu.text.SimpleDateFormat;
import com.ibm.icu.util.TimeZone;
import com.ibm.icu.util.ULocale;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.ElsTeacherCertification;
import com.nicico.training.dto.ElsTeacherCertificationDate;
import com.nicico.training.dto.TeacherCertificationBaseResponse;
import com.nicico.training.dto.TeacherCertificationDTO;
import com.nicico.training.iservice.ICategoryService;
import com.nicico.training.iservice.ISubcategoryService;
import com.nicico.training.iservice.ITeacherCertificationService;
import com.nicico.training.iservice.ITeacherService;
import com.nicico.training.model.Category;
import com.nicico.training.model.Subcategory;
import com.nicico.training.model.Teacher;
import com.nicico.training.model.TeacherCertification;
import com.nicico.training.repository.TeacherCertificationDAO;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.ZoneId;
import java.util.*;

import static com.nicico.training.utility.persianDate.PersianDate.getEpochDate;

@Service
@RequiredArgsConstructor
public class TeacherCertificateService implements ITeacherCertificationService {

    private final ModelMapper modelMapper;
    private final TeacherCertificationDAO teacherCertificationDAO;
    private final ITeacherService teacherService;
    private final ICategoryService categoryService;
    private final ISubcategoryService subcategoryService;

    @Transactional(readOnly = true)
    @Override
    public TeacherCertificationDTO.Info get(Long id) {
        return modelMapper.map(getTeacherCertification(id), TeacherCertificationDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public TeacherCertification getTeacherCertification(Long id) {
        final Optional<TeacherCertification> optionalTeacherCertification = teacherCertificationDAO.findById(id);
        return optionalTeacherCertification.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
    }

    @Override
    public ElsTeacherCertification saveCertification(TeacherCertification teacherCertification, ElsTeacherCertification elsTeacherCertification) {
        TeacherCertification saved= teacherCertificationDAO.save(teacherCertification);
        ElsTeacherCertification dto=new ElsTeacherCertification();
        if(saved!=null) {
           dto.setId(saved.getId());
           dto.setCourseTitle(saved.getCourseTitle());
           dto.setCertificationStatus(elsTeacherCertification.getCertificationStatus());
           dto.setCourseDate(elsTeacherCertification.getCourseDate());
           dto.setCompanyName(saved.getCompanyName());




        }
      return  dto;
    }

    @Transactional
    @Override
    public void deleteTeacherCertification(Long teacherId, Long teacherCertificationId) {
        final Teacher teacher = teacherService.getTeacher(teacherId);
        final TeacherCertificationDTO.Info teacherCertification = get(teacherCertificationId);
        try {
            teacher.getTeacherCertifications().remove(modelMapper.map(teacherCertification, TeacherCertification.class));
            teacherCertification.setTeacherId(null);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }

    @Override
    @Transactional
    public TeacherCertificationBaseResponse editTeacherCertification(ElsTeacherCertification elsTeacherCertification) {
        TeacherCertificationBaseResponse response=new TeacherCertificationBaseResponse();

       try {
           Long teacherCertificationId = elsTeacherCertification.getId();

           TeacherCertification optionalTeacherCertification = teacherCertificationDAO.getById(teacherCertificationId);
           if (optionalTeacherCertification.getId() != null) {
               TeacherCertification teacherCertification = optionalTeacherCertification;
               teacherCertification.setCourseTitle(elsTeacherCertification.getCourseTitle());
               teacherCertification.setCompanyName(elsTeacherCertification.getCompanyName());
               if (elsTeacherCertification.getCourseDate() != null) {
                   Date date = new Date(elsTeacherCertification.getCourseDate());
                   String persianDate = convertToPersianDate(date);
                   teacherCertification.setStartDate(persianDate);
               }
               teacherCertification.setCertificationStatus(elsTeacherCertification.getCertificationStatus());

               if (elsTeacherCertification.getCategoryIds() != null && elsTeacherCertification.getCategoryIds().size() > 0) {

                   Set<Category> categories = categoryService.getCategoriesByIds(elsTeacherCertification.getCategoryIds());
                   if (categories != null)
                       teacherCertification.setCategories(categories);
               }

               if (elsTeacherCertification.getSubcategoryIds() != null && elsTeacherCertification.getSubcategoryIds().size() > 0) {

                   Set<Subcategory> subcategories = subcategoryService.getSubcategoriesByIds(elsTeacherCertification.getSubcategoryIds());
                   if (subcategories != null)
                       teacherCertification.setSubCategories(subcategories);

               }
               TeacherCertification finalResult = teacherCertificationDAO.saveAndFlush(teacherCertification);
               if (finalResult != null) {
                   response.setElsTeacherCertification(elsTeacherCertification);
                   response.setMessage("successfully edited!");
                   response.setStatus(200);
                   return response;
               } else {
                   response.setStatus(406);
                   response.setMessage("not edited!");
                   return response;
               }


           }
       }catch (Exception e){
           response.setStatus(406);
           response.setMessage("questionId does not exist");
            return response;
       }

     return response;

    }

    @Override
    public List<TeacherCertification> findAllTeacherCertifications(Long teacherId) {
       return teacherCertificationDAO.findAllByTeacherId(teacherId);
    }

    @Override
    public ElsTeacherCertification getElsTeacherCertification(Long id) {

        ElsTeacherCertification response=new ElsTeacherCertification();
       Optional<TeacherCertification> optional=teacherCertificationDAO.findById(id);
       if(optional.isPresent()){
           response.setId(optional.get().getId());
           response.setCompanyName(optional.get().getCompanyName());
           response.setCourseTitle(optional.get().getCourseTitle());

           response.setCertificationStatus(optional.get().getCertificationStatus());
           response.setCourseDate(getPublicationDate(optional.get().getStartDate()));
           response.setCompanyName(optional.get().getCompanyName());
           response.setCategoryIds(teacherCertificationDAO.getCategories(id));
           response.setSubcategoryIds(teacherCertificationDAO.getSubcategories(id));

           response.setStatus(200);
           response.setMessage("successfully get");


       }else{
           response.setStatus(406);
           response.setMessage("get failed!");
       }
       return response;
    }
   private Long getPublicationDate(String publicationDate) {
        if (publicationDate != null) {
            Date date = getEpochDate(publicationDate, "04:30");
            return (date.getTime() * 1000);
        } else {
            return null;
        }
    }

    private String convertToPersianDate(Date _date) {
        Long date = _date.getTime();
        ULocale PERSIAN_LOCALE = new ULocale("fa_IR");
        ZoneId IRAN_ZONE_ID = ZoneId.of("Asia/Tehran");

        SimpleDateFormat df = new SimpleDateFormat("yyyy/MM/dd", PERSIAN_LOCALE );
        df.setTimeZone(TimeZone.getTimeZone("GMT+3:30"));
        return df.format(date);
    }


    @Transactional
    @Override
    public void addTeacherCertification(TeacherCertificationDTO.Create request, Long teacherId,HttpServletResponse response) {
        final Teacher teacher = teacherService.getTeacher(teacherId);

        if (!teacherCertificationDAO.existsByCourseTitleAndTeacherId(request.getCourseTitle(),request.getTeacherId())){
            TeacherCertification teacherCertification = new TeacherCertification();
            modelMapper.map(request, teacherCertification);
            try {
                teacher.getTeacherCertifications().add(teacherCertification);
            } catch (ConstraintViolationException | DataIntegrityViolationException e) {
                throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
            }
        }
        else {
            try {
                response.sendError(405,null);
            } catch (IOException e){
                throw new TrainingException(TrainingException.ErrorType.InvalidData);
            }
        }
    }

    @Transactional
    @Override
    public TeacherCertificationDTO.Info update(Long id, TeacherCertificationDTO.Update request, HttpServletResponse response) {
        final TeacherCertification teacherCertification = getTeacherCertification(id);

        if (!teacherCertificationDAO.existsByCourseTitleAndTeacherIdAndIdIsNot(request.getCourseTitle(),request.getTeacherId(),id)) {
            teacherCertification.getCategories().clear();
            teacherCertification.getSubCategories().clear();
            TeacherCertification updating = new TeacherCertification();
            modelMapper.map(teacherCertification, updating);
            modelMapper.map(request, updating);
            try {
                return save(updating);
            } catch (ConstraintViolationException | DataIntegrityViolationException e) {
                throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
            }
        }
        else {
            try {
                response.sendError(405, null);
                return null;
            } catch (IOException e) {
                throw new TrainingException(TrainingException.ErrorType.InvalidData);
            }
        }
    }


    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<TeacherCertificationDTO.Info> search(SearchDTO.SearchRq request, Long teacherId) {
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
                if (criteriaRq.getFieldName().equalsIgnoreCase("persianStartDate"))
                    criteriaRq.setFieldName("startDate");
                if (criteriaRq.getFieldName().equalsIgnoreCase("persianEndDate"))
                    criteriaRq.setFieldName("endDate");
            }
        }
        return SearchUtil.search(teacherCertificationDAO, request, teacherCertification -> modelMapper.map(teacherCertification, TeacherCertificationDTO.Info.class));
    }

    private TeacherCertificationDTO.Info save(TeacherCertification teacherCertification) {
        final TeacherCertification saved = teacherCertificationDAO.saveAndFlush(teacherCertification);
        return modelMapper.map(saved, TeacherCertificationDTO.Info.class);
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
