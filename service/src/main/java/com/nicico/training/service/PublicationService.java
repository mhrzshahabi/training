package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.PublicationDTO;
import com.nicico.training.dto.teacherPublications.ElsPublicationDTO;
import com.nicico.training.dto.teacherPublications.TeacherPublicationResponseDTO;
import com.nicico.training.iservice.IPublicationService;
import com.nicico.training.iservice.ITeacherService;
import com.nicico.training.mapper.teacherPublication.TeacherPublicationBeanMapper;
import com.nicico.training.model.Publication;
import com.nicico.training.model.Teacher;
import com.nicico.training.repository.PublicationDAO;
import com.nicico.training.utility.persianDate.MyUtils;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.BaseResponse;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PublicationService implements IPublicationService {

    private final ModelMapper modelMapper;
    private final PublicationDAO publicationDAO;
    private final ITeacherService teacherService;
    private final TeacherPublicationBeanMapper teacherPublicationBeanMapper;

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
    public void addPublication(PublicationDTO.Create request, Long teacherId,HttpServletResponse response) {
        final Teacher teacher = teacherService.getTeacher(teacherId);
        Publication publication = new Publication();

        if (!publicationDAO.existsBySubjectTitleAndTeacherId(request.getSubjectTitle(),request.getTeacherId())){
            modelMapper.map(request, publication);
            try {
                teacher.getPublications().add(publication);
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
    public PublicationDTO.Info update(Long id, PublicationDTO.Update request,HttpServletResponse response) {
        final Publication publication = getPublication(id);

        if (!publicationDAO.existsBySubjectTitleAndTeacherIdAndIdIsNot(request.getSubjectTitle(),request.getTeacherId(),id)) {
            publication.getCategories().clear();
            publication.getSubCategories().clear();
            Publication updating = new Publication();
            modelMapper.map(publication, updating);
            modelMapper.map(request, updating);
            try {
                return save(updating,response);
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

    @Transactional
    @Override
    public PublicationDTO.Info save(Publication publication, HttpServletResponse response) {
            final Publication saved = publicationDAO.saveAndFlush(publication);
            return modelMapper.map(saved, PublicationDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public TeacherPublicationResponseDTO findTeacherPublicationsByNationalCode(String nationalCode) {
        TeacherPublicationResponseDTO teacherPublicationResponseDTO = new TeacherPublicationResponseDTO();
        if (MyUtils.validateNationalCode(nationalCode)) {
            Long teacherId = teacherService.getTeacherIdByNationalCode(nationalCode);
            if (teacherId == null) {
                teacherPublicationResponseDTO.setStatus(HttpStatus.NO_CONTENT.value());
                teacherPublicationResponseDTO.setMessage("اطلاعات استاد با کد ملی " + nationalCode + " موجود نیست.");
            } else {
                List<Publication> publications = publicationDAO.findAllByTeacherIdOrderByIdDesc(teacherId);
                List<ElsPublicationDTO.Info> infoList = teacherPublicationBeanMapper.toElsPublicationDTOInfoList(publications);
                teacherPublicationResponseDTO.setPublicationDTOInfoList(infoList);
                teacherPublicationResponseDTO.setStatus(200);
            }
        } else {
            teacherPublicationResponseDTO.setStatus(HttpStatus.BAD_REQUEST.value());
            teacherPublicationResponseDTO.setMessage("کدملی معتبر نیست");
        }
        return teacherPublicationResponseDTO;
    }

    @Override
    public List<ElsPublicationDTO.Resume> findTeacherPublicationsResumeListByNationalCode(String nationalCode) {

        Long teacherId = teacherService.getTeacherIdByNationalCode(nationalCode);
        if (teacherId == null) {
            return null;
        } else {
            List<Publication> publications = publicationDAO.findAllByTeacherIdOrderByIdDesc(teacherId);
            List<ElsPublicationDTO.Resume> resumeList = teacherPublicationBeanMapper.toElsPublicationResumeDTOList(publications.stream().sorted(Comparator.comparing(Publication::getId)).collect(Collectors.toList()));
            return resumeList;
        }
    }

    @Override
    @Transactional
    public ElsPublicationDTO.UpdatedInfo create(ElsPublicationDTO.Create elsPublicationDTO) {
        ElsPublicationDTO.UpdatedInfo response = new ElsPublicationDTO.UpdatedInfo();
        try {
            Long teacherId = teacherService.getTeacherIdByNationalCode(elsPublicationDTO.getNationalCode());
            if (teacherId != null) {
                elsPublicationDTO.setTeacherId(teacherId);
                ElsPublicationDTO.Create2 elsPublicationCreate2 = teacherPublicationBeanMapper.toPublicationCreate2(elsPublicationDTO);
                Publication publication = teacherPublicationBeanMapper.toPublication(elsPublicationCreate2);
                Publication finalPublication = publicationDAO.save(publication);
                response = teacherPublicationBeanMapper.toTeacherUpdatedPublicationInfoDto(finalPublication);
                response.setStatus(HttpStatus.OK.value());

            } else {
                response.setStatus(HttpStatus.NO_CONTENT.value());
                response.setMessage("استاد با این اطلاعات یافت نشد");
            }
        } catch (Exception e) {
            response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
            response.setMessage(((TrainingException) e).getMsg());
        }
        return response;
    }

    @Override
    @Transactional
    public ElsPublicationDTO.UpdatedInfo updateElsPub(ElsPublicationDTO.Update elsPublicationDTO) {
        ElsPublicationDTO.UpdatedInfo response = new ElsPublicationDTO.UpdatedInfo();
        try {
            Optional<Publication> mainOptionalPublication = publicationDAO.findById(elsPublicationDTO.getId());
            if (mainOptionalPublication.isPresent()) {
                Publication mainPublication = mainOptionalPublication.get();
                ElsPublicationDTO.Update2 elsPublicationUpdateDto2 = teacherPublicationBeanMapper.toPublicationUpdateDto2(elsPublicationDTO);
                Publication publication = teacherPublicationBeanMapper.toTeacherUpdatedPublication(elsPublicationUpdateDto2);
                mainPublication.setPublicationDate(publication.getPublicationDate());
                mainPublication.setSubjectTitle(publication.getSubjectTitle());
                mainPublication.setPublicationDate(publication.getPublicationDate());
                mainPublication.setPublisher(publication.getPublisher());
                mainPublication.setPublicationSubjectTypeId(publication.getPublicationSubjectTypeId());
                mainPublication.setCategories(publication.getCategories());
                mainPublication.setSubCategories(publication.getSubCategories());
                mainPublication.setPublicationNumber(publication.getPublicationNumber());

                Publication result = publicationDAO.save(mainPublication);
                response = teacherPublicationBeanMapper.toTeacherUpdatedPublicationInfoDto(result);
                response.setStatus(HttpStatus.OK.value());
            } else {
                response.setStatus(HttpStatus.NO_CONTENT.value());
                response.setMessage("سابقه مورد نظر یافت نشد");
            }
        } catch (Exception e) {
            response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
            response.setMessage(((TrainingException) e).getMsg());
        }

        return response;
    }

    @Override
    public BaseResponse deleteTeacherPublication(Long id) {
        BaseResponse baseResponse = new BaseResponse();
        try {
            Optional<Publication> mainOptionalPublication = publicationDAO.findById(id);
            if (mainOptionalPublication.isPresent()) {
                publicationDAO.deleteById(id);
                baseResponse.setStatus(HttpStatus.OK.value());
            } else {
                baseResponse.setStatus(HttpStatus.NO_CONTENT.value());
                baseResponse.setMessage("سابقه مورد نظر یافت نشد");
            }
        } catch (Exception e) {
            baseResponse.setMessage("حذف سابقه امکان پذیر نیست");
            baseResponse.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
        }
        return baseResponse;
    }

    @Transactional(readOnly = true)
    @Override
    public ElsPublicationDTO.UpdatedInfo getOneById(Long id) {
        ElsPublicationDTO.UpdatedInfo response = new ElsPublicationDTO.UpdatedInfo();
        try {
            Optional<Publication> teacherPublication = publicationDAO.findById(id);
            if (teacherPublication.isPresent()) {
                response = teacherPublicationBeanMapper.toTeacherUpdatedPublicationInfoDto(teacherPublication.get());
                response.setStatus(HttpStatus.OK.value());
            } else {
                response.setStatus(HttpStatus.NO_CONTENT.value());
                response.setMessage("مدرک مورد نظر یافت نشد");
            }
        } catch (Exception e) {
            response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
            response.setMessage(((TrainingException) e).getMsg());
        }
        return response;
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
