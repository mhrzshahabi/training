package com.nicico.training.service;

import com.nicico.bpmsclient.model.flowable.process.ProcessInstance;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CompetenceDTO;
import com.nicico.training.dto.NeedsAssessmentDTO;
import com.nicico.training.iservice.IBpmsService;
import com.nicico.training.iservice.ICompetenceService;
import com.nicico.training.mapper.bpmsNeedAssessment.CompetenceBeanMapper;
import com.nicico.training.model.Competence;
import com.nicico.training.model.NeedsAssessment;
import com.nicico.training.model.NeedsAssessmentTemp;
import com.nicico.training.model.Skill;
import com.nicico.training.repository.CompetenceDAO;
import com.nicico.training.repository.NeedsAssessmentDAO;
import com.nicico.training.repository.NeedsAssessmentTempDAO;
import com.nicico.training.repository.SkillDAO;
import dto.bpms.BpmsStartParamsDto;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.BaseResponse;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Optional;

@RequiredArgsConstructor
@Service
public class CompetenceService extends BaseService<Competence, Long, CompetenceDTO.Info, CompetenceDTO.Create, CompetenceDTO.Update, CompetenceDTO.Delete, CompetenceDAO> implements ICompetenceService {

    @Autowired
    private IBpmsService bPMSService;
    @Autowired
    private MessageSource messageSource;
    @Autowired
    private CompetenceDAO competenceDAO;
    @Autowired
    private NeedsAssessmentDAO needsAssessmentDAO;
    @Autowired
    private SkillDAO skillDAO;
    @Autowired
    private CompetenceBeanMapper competenceBeanMapper;
    @Autowired
    private ParameterValueService parameterValueService;
    @Autowired
    private NeedsAssessmentTempDAO needsAssessmentTempDAO;

    @Autowired
    CompetenceService(CompetenceDAO competenceDAO) {
        super(new Competence(), competenceDAO);
    }

    @Transactional
    public BaseResponse checkAndCreateInBPMS(BpmsStartParamsDto params, HttpServletResponse response) {

        BaseResponse baseResponse = new BaseResponse();
        try {
            CompetenceDTO.Create create = competenceBeanMapper.toCompetence(params.getRq());
            if (parameterValueService.isExist(create.getCompetenceTypeId()) && !dao.existsByTitle(create.getTitle())) {
                create.setCode(codeCompute(create.getCode()));
                CompetenceDTO.Info info = create(create);
                ProcessInstance processInstance = bPMSService.startProcessWithData(bPMSService.getStartProcessDto(params, "Training","COMPETENCE"));
                CompetenceDTO.Update update = modelMapper.map(info, CompetenceDTO.Update.class);
                update.setProcessInstanceId(processInstance.getId());
                checkAndUpdate(info.getId(), update, response);
                baseResponse.setStatus(200);
            } else {
                baseResponse.setStatus(405);
                baseResponse.setMessage("عنوان شایستگی تکراری است");
            }
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            baseResponse.setStatus(404);
            baseResponse.setMessage("مشکلی در ایجاد شایستگی وجود دارد");
        } catch (Exception e) {
            baseResponse.setStatus(406);
            baseResponse.setMessage("ارسال به گردش کار انجام نشد، لطفا دوباره تلاش کنيد");
        }
        return baseResponse;
    }

    @Transactional
    public CompetenceDTO.Info checkAndCreate(CompetenceDTO.Create rq, HttpServletResponse response) {
        try {
            Long competenceTypeId = rq.getCompetenceTypeId();
            if (parameterValueService.isExist(competenceTypeId) && !dao.existsByTitle(rq.getTitle())) {
                rq.setCode(codeCompute(rq.getCode()));
                return create(rq);
            } else if (dao.existsByTitle(rq.getTitle())) {
                Locale locale = LocaleContextHolder.getLocale();
                response.sendError(401, messageSource.getMessage("publication.title.duplicate", null, locale));
            } else
                throw new TrainingException(TrainingException.ErrorType.CompetenceTypeNotFound);
        } catch (ConstraintViolationException | DataIntegrityViolationException | IOException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
        return null;
    }

    @Override
    @Transactional
    public CompetenceDTO.Info delete(Long id) {
        final Optional<Competence> optional = dao.findById(id);
        final Competence entity = optional.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

        try {
            needsAssessmentDAO.deleteByCompetenceId(id);
            needsAssessmentTempDAO.deleteByCompetenceId(id);
            dao.deleteById(id);
            return modelMapper.map(entity, CompetenceDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }

    @Override
    public SearchDTO.SearchRs<CompetenceDTO.Posts> searchPosts(Long id, Integer startRow, Integer endRow) {
        List<CompetenceDTO.Posts> list =new ArrayList<>();
        SearchDTO.SearchRs<CompetenceDTO.Posts> data= new SearchDTO.SearchRs<CompetenceDTO.Posts>();
        int page=0;
        int mode =((75-startRow)%75);
        if (mode==0)
            page =((75-startRow)/75)-1;
        else
            page =((75-startRow)/75);

        Pageable pageable = PageRequest.of(page, 75-startRow, Sort.by(
                Sort.Order.desc("id")
        ));
        Page<NeedsAssessment> needsAssessments = needsAssessmentDAO.findAllByCompetenceId(id,pageable);

        for (NeedsAssessment needsAssessment :needsAssessments){
            CompetenceDTO.Posts  item = new CompetenceDTO.Posts();
            item.setCode(needsAssessment.getObjectCode());
            item.setTitle(needsAssessment.getObjectName());
            item.setId(needsAssessment.getId());
            item.setType(getType(needsAssessment.getObjectType()));
            Optional<Skill> skill=skillDAO.findById(needsAssessment.getSkillId());
            skill.ifPresent(value -> item.setSkill(value.getTitleFa()));

            list.add(item);
        }

        data.setList(list);

            data.setTotalCount(needsAssessments.getTotalElements());

        return data;
    }

    @Override
    public  SearchDTO.SearchRs<CompetenceDTO.Posts>  searchTempPosts(Long competenceId, Integer startRow, Integer endRow) {
        List<CompetenceDTO.Posts> list =new ArrayList<>();
        SearchDTO.SearchRs<CompetenceDTO.Posts> data= new SearchDTO.SearchRs<CompetenceDTO.Posts>();
        int page=0;
        int mode =((75-startRow)%75);
        if (mode==0)
            page =((75-startRow)/75)-1;
        else
            page =((75-startRow)/75);

        Pageable pageable = PageRequest.of(page, 75-startRow, Sort.by(
                Sort.Order.desc("id")
        ));
        Page<NeedsAssessmentTemp> needsAssessments = needsAssessmentTempDAO.findAllByCompetenceId(competenceId,pageable);

        for (NeedsAssessmentTemp needsAssessment :needsAssessments){
            CompetenceDTO.Posts  item = new CompetenceDTO.Posts();
            item.setCode(needsAssessment.getObjectCode());
            item.setTitle(needsAssessment.getObjectName());
            item.setId(needsAssessment.getId());
            item.setType(getType(needsAssessment.getObjectType()));
           Optional<Skill> skill=skillDAO.findById(needsAssessment.getSkillId());
            skill.ifPresent(value -> item.setSkill(value.getTitleFa()));

            list.add(item);
        }

        data.setList(list);
        data.setTotalCount(needsAssessments.getTotalElements());

        return data;
    }
    public String getType(String type) {
        switch (type) {
            case "TrainingPost":
                return "پست";
            case "Post":
                return "پست انفرادی";
            case "PostGrade":
                return "رده پستی ";
            case "PostGroup":
                return "پست گروهی";
            case "Job":
                return "شغل";
            default:
                return type;
        }
    }
    @Transactional
    public CompetenceDTO.Info checkAndUpdate(Long id, CompetenceDTO.Update rq, HttpServletResponse response) {
        try {
            if (!dao.existsByTitleAndIdIsNot(rq.getTitle(), id)) {
                return updateCompetence(id, rq);
            } else {
                Locale locale = LocaleContextHolder.getLocale();
                response.sendError(401, messageSource.getMessage("publication.title.duplicate", null, locale));
            }
        } catch (ConstraintViolationException | DataIntegrityViolationException | IOException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
        return null;
    }

    private CompetenceDTO.Info updateCompetence(Long id, CompetenceDTO.Update rq) {
        Competence currentCompany = competenceDAO.findById(id).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        modelMapper.map(rq, currentCompany);
        try {
            return modelMapper.map(competenceDAO.saveAndFlush(currentCompany), CompetenceDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.conflict);
        }
    }

    @Transactional
    public String codeCompute(String code) {
        long maxCode = competenceDAO.getMaxCode(code + "%");
        if (maxCode == 0) {
            return code + "1";
        }
        return code + maxCode;
    }

    @Transactional
    public List<NeedsAssessmentDTO.Info> getUsedList(Long competenceId) {
        final ArrayList<NeedsAssessmentDTO.Info> needsAssessmentList = new ArrayList<>();
        Optional<NeedsAssessment> needsAssessment = needsAssessmentDAO.findFirstByCompetenceId(competenceId);
        if (needsAssessment.isPresent()) {
            needsAssessmentList.add(modelMapper.map(needsAssessment.get(), NeedsAssessmentDTO.Info.class));
        }
        Optional<NeedsAssessmentTemp> needsAssessmentTemp = needsAssessmentTempDAO.findFirstByCompetenceId(competenceId);
        if (needsAssessmentTemp.isPresent()) {
            needsAssessmentList.add(modelMapper.map(needsAssessmentTemp.get(), NeedsAssessmentDTO.Info.class));
        }
        return needsAssessmentList;
    }

    @Override
    public Boolean checkUsed(Long competenceId) {
        Optional<NeedsAssessment> needsAssessment = needsAssessmentDAO.findFirstByCompetenceId(competenceId);
        if (needsAssessment.isPresent()) {
            return true;
        }
        Optional<NeedsAssessmentTemp> needsAssessmentTemp = needsAssessmentTempDAO.findFirstByCompetenceId(competenceId);
        if (needsAssessmentTemp.isPresent()) {
            return true;
        }
        return false;
    }

    public CompetenceDTO.Info getProcessDetailByProcessInstanceId(String processInstanceId) {
        Optional<Competence> competenceOptional = competenceDAO.findByProcessInstanceId(processInstanceId);
        CompetenceDTO.Info  data= competenceOptional.map(competence -> modelMapper.map(competence, CompetenceDTO.Info.class)).orElse(null);

        if (data != null) {
            data.setCompetenceLevel(parameterValueService.getParameterTitleCodeById(data.getCompetenceLevelId()));
            data.setCompetencePriority(parameterValueService.getParameterTitleCodeById(data.getCompetencePriorityId()));

        }
    return data;
    }


    @Transactional
    public BaseResponse updateStatus(String processInstanceId, Long i, String reason) {
        BaseResponse response = new BaseResponse();
        Optional<Competence> optionalCompetence = competenceDAO.findFirstByProcessInstanceId(processInstanceId);
        if (optionalCompetence.isPresent()) {
            Competence competence = optionalCompetence.get();
            competence.setWorkFlowStatusCode(i);
            if (i.equals(1L))
                competence.setReturnDetail(reason);
            dao.saveAndFlush(competence);
            response.setStatus(200);
        } else {
            response.setStatus(404);
        }
        return response;

    }


    @Override
    public Competence getCompetence(Long id) {
        Optional<Competence> optionalCompetence = competenceDAO.findById(id);
        if (optionalCompetence.isPresent()) {
            return optionalCompetence.get();
        }else {
            throw new TrainingException(TrainingException.ErrorType.CompetenceTypeNotFound);
        }
    }

}