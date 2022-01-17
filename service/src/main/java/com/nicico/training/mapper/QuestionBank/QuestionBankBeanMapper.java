package com.nicico.training.mapper.QuestionBank;


import com.nicico.training.dto.AttachmentDTO;
import com.nicico.training.dto.QuestionBankDTO;
import com.nicico.training.iservice.ICategoryService;
import com.nicico.training.iservice.IQuestionBankService;
import com.nicico.training.iservice.ISubcategoryService;
import com.nicico.training.iservice.ITclassService;
import com.nicico.training.model.*;
import com.nicico.training.model.enums.EQuestionLevel;
import com.nicico.training.service.*;
import com.nicico.training.utility.persianDate.PersianDate;
import dto.exam.EQuestionType;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;
import org.springframework.beans.factory.annotation.Autowired;
import response.question.dto.ElsAttachmentDto;
import response.question.dto.ElsQuestionBankDto;
import response.question.dto.ElsQuestionDto;
import response.question.dto.ElsQuestionOptionDto;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;


@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public abstract class QuestionBankBeanMapper {

    @Autowired
    protected AttachmentService attachmentService;

    @Autowired
    protected ParameterValueService parameterValueService;

    @Autowired
    protected ICategoryService categoryService;

    @Autowired
    protected ISubcategoryService subcategoryService;

    @Autowired
    protected TeacherService teacherService;

    @Autowired
    protected IQuestionBankService questionBankService;

    @Autowired
    protected CourseService courseService;

    @Autowired
    protected ITclassService tClassService;

    @Autowired
    protected PersonalInfoService personalInfoService;


    public ElsQuestionBankDto toElsQuestionBank(List<QuestionBank> questionBankList, String nationalCode) {

        ElsQuestionBankDto elsQuestionBankDto = new ElsQuestionBankDto();
        List<ElsQuestionDto> elsQuestionDtoList = new ArrayList<>();

        questionBankList.forEach(questionBank -> {

            List<ElsAttachmentDto> elsAttachmentDtoFiles = new ArrayList<>();
            List<ElsAttachmentDto> elsAttachmentDtoOption1Files = new ArrayList<>();
            List<ElsAttachmentDto> elsAttachmentDtoOption2Files = new ArrayList<>();
            List<ElsAttachmentDto> elsAttachmentDtoOption3Files = new ArrayList<>();
            List<ElsAttachmentDto> elsAttachmentDtoOption4Files = new ArrayList<>();

            List<ElsQuestionOptionDto> elsQuestionOptionDtoList = new ArrayList<>();
            ElsQuestionDto elsQuestionDto = new ElsQuestionDto();

            boolean option1HasAttachment = false;
            boolean option2HasAttachment = false;
            boolean option3HasAttachment = false;
            boolean option4HasAttachment = false;

            List<Map<String, List<ElsAttachmentDto>>> attachments = attachmentService.getFilesToEls("QuestionBank", questionBank.getId());
            if (attachments != null) {

                for (int i = 0; i < attachments.size(); i++) {
                    Map<String, List<ElsAttachmentDto>> map = attachments.get(i);
                    if (map.containsKey("option1") && map.get("option1").size() != 0) option1HasAttachment = true;
                    if (map.containsKey("option2") && map.get("option2").size() != 0) option2HasAttachment = true;
                    if (map.containsKey("option3") && map.get("option3").size() != 0) option3HasAttachment = true;
                    if (map.containsKey("option4") && map.get("option4").size() != 0) option4HasAttachment = true;
                }

                attachments.forEach(fileType -> {
                    if (fileType.containsKey("file")) {
                        List<ElsAttachmentDto> file = fileType.get("file");
                        elsAttachmentDtoFiles.addAll(file);
                    }
                    if (fileType.containsKey("option1")) {
                        List<ElsAttachmentDto> option1 = fileType.get("option1");
                        elsAttachmentDtoOption1Files.addAll(option1);
                    }
                    if (fileType.containsKey("option2")) {
                        List<ElsAttachmentDto> option2 = fileType.get("option2");
                        elsAttachmentDtoOption2Files.addAll(option2);
                    }
                    if (fileType.containsKey("option3")) {
                        List<ElsAttachmentDto> option3 = fileType.get("option3");
                        elsAttachmentDtoOption3Files.addAll(option3);
                    }
                    if (fileType.containsKey("option4")) {
                        List<ElsAttachmentDto> option4 = fileType.get("option4");
                        elsAttachmentDtoOption4Files.addAll(option4);
                    }
                });
            }

            elsQuestionOptionDtoList.add(new ElsQuestionOptionDto(questionBank.getOption1(), 1, option1HasAttachment, elsAttachmentDtoOption1Files));
            elsQuestionOptionDtoList.add(new ElsQuestionOptionDto(questionBank.getOption2(), 2, option2HasAttachment, elsAttachmentDtoOption2Files));
            elsQuestionOptionDtoList.add(new ElsQuestionOptionDto(questionBank.getOption3(), 3, option3HasAttachment, elsAttachmentDtoOption3Files));
            elsQuestionOptionDtoList.add(new ElsQuestionOptionDto(questionBank.getOption4(), 4, option4HasAttachment, elsAttachmentDtoOption4Files));

            elsQuestionDto.setQuestionId(questionBank.getId());
            elsQuestionDto.setTitle(questionBank.getQuestion());
            elsQuestionDto.setType(mapAnswerType(questionBank.getQuestionTypeId()));
            elsQuestionDto.setQuestionLevel(questionBank.getEQuestionLevel().getTitleFa());

            elsQuestionDto.setQuestionTargetIds(questionBank.getQuestionTargets());
            elsQuestionDto.setCategoryId(questionBank.getCategoryId());
            elsQuestionDto.setCategoryName(questionBank.getCategoryId() != null ? categoryService.get(questionBank.getCategoryId()).getTitleFa() : null);
            elsQuestionDto.setSubCategory(questionBank.getSubCategoryId());
            elsQuestionDto.setSubCategoryName(questionBank.getSubCategoryId() != null ? subcategoryService.get(questionBank.getSubCategoryId()).getTitleFa() : null);
            elsQuestionDto.setOptionList(elsQuestionOptionDtoList);
            elsQuestionDto.setCorrectOption(questionBank.getMultipleChoiceAnswer());
            elsQuestionDto.setCorrectAnswer(questionBank.getDescriptiveAnswer());
            elsQuestionDto.setHasAttachment(questionBank.getHasAttachment());
            elsQuestionDto.setFiles(elsAttachmentDtoFiles);
            elsQuestionDto.setQuestionCode(questionBank.getCode());
            if(questionBank.getDisplayTypeId()!=null){
             Long id= questionBank.getDisplayTypeId();
           ParameterValue displayType=  parameterValueService.get(id);
                elsQuestionDto.setDisplayType(displayType.getType());
            }

            if(questionBank.getTeacherId()!=null){
             Teacher teacher= teacherService.getTeacher(questionBank.getTeacherId());
             if(teacher.getPersonalityId()!=null)  {
                 PersonalInfo personalInfo=personalInfoService.getPersonalInfo(teacher.getPersonalityId());
                 if(personalInfo!=null) {
                     String name = personalInfo.getFirstNameFa() != null ? personalInfo.getFirstNameFa() : "";
                     String lastName = personalInfo.getLastNameFa() != null ? personalInfo.getLastNameFa() : "";
                     elsQuestionDto.setTeacherFullName(name + " " + lastName);
                 }
              }
            }

            if(questionBank.getCourseId()!=null){
               Course course= courseService.getCourse(questionBank.getCourseId());
               elsQuestionDto.setCourseName(course.getTitleFa());
            }


            if(questionBank.getTclassId()!=null) {
                Tclass tclass=tClassService.getTClass(questionBank.getTclassId());
                elsQuestionDto.setClassName(tclass.getTitleClass());
                elsQuestionDto.setClassCode(tclass.getCode());
                elsQuestionDto.setStartDate(tclass.getStartDate());
                elsQuestionDto.setFinishDate(tclass.getEndDate());
            }
            elsQuestionDto.setCreatedBy(questionBank.getCreatedBy()!=null ? questionBank.getCreatedBy() : null);
            elsQuestionDto.setCreatedDate(questionBank.getCreatedDate()!=null? PersianDate.convertToTrainingPersianDate(questionBank.getCreatedDate()):null);
//            elsQuestionDto.setDescription();
//            elsQuestionDto.setAnswerTime();

            elsQuestionDtoList.add(elsQuestionDto);
        });

        elsQuestionBankDto.setNationalCode(nationalCode);
        elsQuestionBankDto.setQuestions(elsQuestionDtoList);
        return elsQuestionBankDto;
    }

    public List<QuestionBankDTO.Info> toQuestionBankCreate(ElsQuestionBankDto elsQuestionBankDto) {

        List<QuestionBankDTO.Info> questionBankDtoList = new ArrayList<>();

        String nationalCode = elsQuestionBankDto.getNationalCode();
        Long teacherId = teacherService.getTeacherIdByNationalCode(nationalCode);
        List<ElsQuestionDto> elsQuestionDtos = elsQuestionBankDto.getQuestions();
        elsQuestionDtos.forEach(elsQuestionDto -> {

            QuestionBankDTO.Create create = new QuestionBankDTO.Create();
            Tclass tClass = tClassService.getClassByCode(elsQuestionDto.getClassCode());

            List<ElsAttachmentDto> files = elsQuestionDto.getFiles();
            List<ElsAttachmentDto> option1Files = new ArrayList<>();
            List<ElsAttachmentDto> option2Files = new ArrayList<>();
            List<ElsAttachmentDto> option3Files = new ArrayList<>();
            List<ElsAttachmentDto> option4Files = new ArrayList<>();

            create.setQuestion(elsQuestionDto.getTitle());
            create.setQuestionTypeId(reMapAnswerType(elsQuestionDto.getType()));
            create.setCategoryId(elsQuestionDto.getCategoryId());
            create.setSubCategoryId(elsQuestionDto.getSubCategory());
            create.setQuestionTargets(elsQuestionDto.getQuestionTargetIds());
            create.setTeacherId(teacherId);
            create.setLines(1);
            create.setDisplayTypeId(521L);
            create.setDescriptiveAnswer(elsQuestionDto.getCorrectAnswer());
            create.setMultipleChoiceAnswer(elsQuestionDto.getCorrectOption());
            create.setHasAttachment(elsQuestionDto.getHasAttachment());
            create.setQuestionLevelId(mapQuestionLevel(elsQuestionDto.getQuestionLevel()));
            create.setTclassId(tClass.getId());
            create.setCourseId(tClass.getCourseId());
            create.setCategoryId(tClass.getCourse().getCategoryId());
            create.setSubCategoryId(tClass.getCourse().getSubCategoryId());

            List<ElsQuestionOptionDto> optionList = elsQuestionDto.getOptionList();
            if (optionList.size() != 0) {

                Optional<ElsQuestionOptionDto> option1 = optionList.stream().filter(option -> option.getOptionNumber() == 1).findFirst();
                if (option1.isPresent()) {
                    create.setOption1(option1.get().getTitle());
                    option1Files.addAll(option1.get().getOptionFiles());
                }
                Optional<ElsQuestionOptionDto> option2 = optionList.stream().filter(option -> option.getOptionNumber() == 2).findFirst();
                if (option2.isPresent()) {
                    create.setOption2(option2.get().getTitle());
                    option2Files.addAll(option2.get().getOptionFiles());
                }
                Optional<ElsQuestionOptionDto> option3 = optionList.stream().filter(option -> option.getOptionNumber() == 3).findFirst();
                if (option3.isPresent()) {
                    create.setOption3(option3.get().getTitle());
                    option3Files.addAll(option3.get().getOptionFiles());
                }
                Optional<ElsQuestionOptionDto> option4 = optionList.stream().filter(option -> option.getOptionNumber() == 4).findFirst();
                if (option4.isPresent()) {
                    create.setOption4(option4.get().getTitle());
                    option4Files.addAll(option4.get().getOptionFiles());
                }
            }

            QuestionBankDTO.Info info = questionBankService.create(create);
            if (files.size() != 0) {
                for (ElsAttachmentDto elsAttachmentDto : files) {
                    AttachmentDTO.Create attachmentDTO = mapElsAttachmentToAttachmentCreate(elsAttachmentDto, info.getId(), "file");
                    attachmentService.create(attachmentDTO);
                }
            }
            if (option1Files.size() != 0) {
                for (ElsAttachmentDto elsAttachmentDto : option1Files) {
                    AttachmentDTO.Create attachmentDTO = mapElsAttachmentToAttachmentCreate(elsAttachmentDto, info.getId(), "option1");
                    attachmentService.create(attachmentDTO);
                }
            }
            if (option2Files.size() != 0) {
                for (ElsAttachmentDto elsAttachmentDto : option2Files) {
                    AttachmentDTO.Create attachmentDTO = mapElsAttachmentToAttachmentCreate(elsAttachmentDto, info.getId(), "option2");
                    attachmentService.create(attachmentDTO);
                }
            }
            if (option3Files.size() != 0) {
                for (ElsAttachmentDto elsAttachmentDto : option3Files) {
                    AttachmentDTO.Create attachmentDTO = mapElsAttachmentToAttachmentCreate(elsAttachmentDto, info.getId(), "option3");
                    attachmentService.create(attachmentDTO);
                }
            }
            if (option4Files.size() != 0) {
                for (ElsAttachmentDto elsAttachmentDto : option4Files) {
                    AttachmentDTO.Create attachmentDTO = mapElsAttachmentToAttachmentCreate(elsAttachmentDto, info.getId(), "option4");
                    attachmentService.create(attachmentDTO);
                }
            }

            questionBankDtoList.add(info);
        });
        return questionBankDtoList;
    }

    public ElsQuestionDto toQuestionBankEdit(ElsQuestionDto elsQuestionDto, long id, Long teacherId) {

        QuestionBankDTO.Update update = new QuestionBankDTO.Update();

        List<ElsAttachmentDto> files = elsQuestionDto.getFiles();
        List<ElsAttachmentDto> option1Files = new ArrayList<>();
        List<ElsAttachmentDto> option2Files = new ArrayList<>();
        List<ElsAttachmentDto> option3Files = new ArrayList<>();
        List<ElsAttachmentDto> option4Files = new ArrayList<>();

        update.setQuestion(elsQuestionDto.getTitle());
        update.setQuestionTypeId(reMapAnswerType(elsQuestionDto.getType()));
        update.setCategoryId(elsQuestionDto.getCategoryId());
        update.setSubCategoryId(elsQuestionDto.getSubCategory());
        update.setQuestionTargets(elsQuestionDto.getQuestionTargetIds());
        update.setLines(1);
        update.setDisplayTypeId(521L);
        update.setTeacherId(teacherId);
        update.setDescriptiveAnswer(elsQuestionDto.getCorrectAnswer());
        update.setMultipleChoiceAnswer(elsQuestionDto.getCorrectOption());
        update.setHasAttachment(elsQuestionDto.getHasAttachment());
        update.setQuestionLevelId(mapQuestionLevel(elsQuestionDto.getQuestionLevel()));

        List<ElsQuestionOptionDto> optionList = elsQuestionDto.getOptionList();
        if (optionList.size() != 0) {

            Optional<ElsQuestionOptionDto> option1 = optionList.stream().filter(option -> option.getOptionNumber() == 1).findFirst();
            if (option1.isPresent()) {
                update.setOption1(option1.get().getTitle());
                option1Files.addAll(option1.get().getOptionFiles());
            }
            Optional<ElsQuestionOptionDto> option2 = optionList.stream().filter(option -> option.getOptionNumber() == 2).findFirst();
            if (option2.isPresent()) {
                update.setOption2(option2.get().getTitle());
                option2Files.addAll(option2.get().getOptionFiles());
            }
            Optional<ElsQuestionOptionDto> option3 = optionList.stream().filter(option -> option.getOptionNumber() == 3).findFirst();
            if (option3.isPresent()) {
                update.setOption3(option3.get().getTitle());
                option3Files.addAll(option3.get().getOptionFiles());
            }
            Optional<ElsQuestionOptionDto> option4 = optionList.stream().filter(option -> option.getOptionNumber() == 4).findFirst();
            if (option4.isPresent()) {
                update.setOption4(option4.get().getTitle());
                option4Files.addAll(option4.get().getOptionFiles());
            }
        }

        QuestionBankDTO.Info info = questionBankService.update(id, update);

        List<Long> questionAttachments=attachmentService.getFileIds("QuestionBank",id);
        questionAttachments.forEach(questionAttachmentId-> {
            attachmentService.delete(questionAttachmentId);
        });

        if (files.size() != 0) {
            for (ElsAttachmentDto elsAttachmentDto : files) {
                AttachmentDTO.Create attachmentDTO = mapElsAttachmentToAttachmentCreate(elsAttachmentDto, info.getId(), "file");
                attachmentService.create(attachmentDTO);
            }
        }
        if (option1Files.size() != 0) {
            for (ElsAttachmentDto elsAttachmentDto : option1Files) {
                AttachmentDTO.Create attachmentDTO = mapElsAttachmentToAttachmentCreate(elsAttachmentDto, info.getId(), "option1");
                attachmentService.create(attachmentDTO);
            }
        }
        if (option2Files.size() != 0) {
            for (ElsAttachmentDto elsAttachmentDto : option2Files) {
                AttachmentDTO.Create attachmentDTO = mapElsAttachmentToAttachmentCreate(elsAttachmentDto, info.getId(), "option2");
                attachmentService.create(attachmentDTO);
            }
        }
        if (option3Files.size() != 0) {
            for (ElsAttachmentDto elsAttachmentDto : option3Files) {
                AttachmentDTO.Create attachmentDTO = mapElsAttachmentToAttachmentCreate(elsAttachmentDto, info.getId(), "option3");
                attachmentService.create(attachmentDTO);
            }
        }
        if (option4Files.size() != 0) {
            for (ElsAttachmentDto elsAttachmentDto : option4Files) {
                AttachmentDTO.Create attachmentDTO = mapElsAttachmentToAttachmentCreate(elsAttachmentDto, info.getId(), "option4");
                attachmentService.create(attachmentDTO);
            }
        }
        return elsQuestionDto;
    }

    protected String mapAnswerType(Long answerTypeId) {

        String answerTypeCode = parameterValueService.getParameterValueCodeById(answerTypeId);
        switch (answerTypeCode) {
            case "MultipleChoiceAnswer":
                return EQuestionType.MULTI_CHOICES.getValue();
            case "Descriptive":
                return EQuestionType.DESCRIPTIVE.getValue();
            default:
                return null;
        }
    }

    protected Long reMapAnswerType(String type) {

        ParameterValue parameterValue = parameterValueService.getByTitle(type);
        return parameterValue.getId();
    }

    protected Integer mapQuestionLevel(String questionLevel) {

        switch (questionLevel) {
            case "آسان":
                return EQuestionLevel.EASY.getId();
            case "متوسط":
                return EQuestionLevel.MODERATE.getId();
            case "سخت":
                return EQuestionLevel.DIFFICULT.getId();
            default:
                return null;
        }
    }

    protected AttachmentDTO.Create mapElsAttachmentToAttachmentCreate(ElsAttachmentDto elsAttachmentDto, Long objectId, String fileType) {

        AttachmentDTO.Create create = new AttachmentDTO.Create();

        switch (fileType) {
            case "file":
                create.setFileTypeId(1L);
                break;
            case "option1":
                create.setFileTypeId(3L);
                break;
            case "option2":
                create.setFileTypeId(4L);
                break;
            case "option3":
                create.setFileTypeId(5L);
                break;
            case "option4":
                create.setFileTypeId(6L);
                break;
            default:
                break;
        }
        create.setFileName(elsAttachmentDto.getFileName());
        create.setObjectId(objectId);
        create.setObjectType("QuestionBank");
        create.setKey(elsAttachmentDto.getAttachment());
        create.setGroup_id(elsAttachmentDto.getGroupId());
        return create;
    }

}
