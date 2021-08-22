package com.nicico.training.mapper.QuestionBank;


import com.nicico.training.model.QuestionBank;
import com.nicico.training.service.AttachmentService;
import com.nicico.training.service.ParameterValueService;
import dto.exam.EQuestionType;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;
import org.springframework.beans.factory.annotation.Autowired;
import response.question.dto.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;


@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public abstract class QuestionBankBeanMapper {

    @Autowired
    protected AttachmentService attachmentService;

    @Autowired
    protected ParameterValueService parameterValueService;

    public ElsQuestionBankDto toElsQuestionBank(List<QuestionBank> questionBankList, String nationalCode) {

        ElsQuestionBankDto elsQuestionBankDto = new ElsQuestionBankDto();
        List<ElsQuestionDto> elsQuestionDtoList = new ArrayList<>();

        questionBankList.forEach(questionBank -> {

            List<ElsAttachmentDto> elsAttachmentDtoList = new ArrayList<>();
            List<ElsQuestionOptionDto> elsQuestionOptionDtoList = new ArrayList<>();
            ElsQuestionDto elsQuestionDto = new ElsQuestionDto();

            boolean questionHasAttachment = false;
            boolean option1HasAttachment = false;
            boolean option2HasAttachment = false;
            boolean option3HasAttachment = false;
            boolean option4HasAttachment = false;

            List<Map<String, List<ElsAttachmentDto>>> attachments = attachmentService.getFilesToEls("QuestionBank", questionBank.getId());
            if (attachments != null) {

                for (int i = 0; i < attachments.size(); i++) {
                    Map<String, List<ElsAttachmentDto>> map = attachments.get(i);
                    if (map.containsKey("file") && map.get("file").size() != 0)
                        questionHasAttachment = true;
                    if (map.containsKey("option1") && map.get("option1").size() != 0)
                        option1HasAttachment = true;
                    if (map.containsKey("option2") && map.get("option2").size() != 0)
                        option2HasAttachment = true;
                    if (map.containsKey("option3") && map.get("option3").size() != 0)
                        option3HasAttachment = true;
                    if (map.containsKey("option4") && map.get("option4").size() != 0)
                        option4HasAttachment = true;
                }

                attachments.forEach(fileType -> {
                    if (fileType.containsKey("file")) {
                        List<ElsAttachmentDto> file = fileType.get("file");
                        elsAttachmentDtoList.addAll(file);
                    }
                    if (fileType.containsKey("option1")) {
                        List<ElsAttachmentDto> option1 = fileType.get("option1");
                        elsAttachmentDtoList.addAll(option1);
                    }
                    if (fileType.containsKey("option2")) {
                        List<ElsAttachmentDto> option2 = fileType.get("option2");
                        elsAttachmentDtoList.addAll(option2);
                    }
                    if (fileType.containsKey("option3")) {
                        List<ElsAttachmentDto> option3 = fileType.get("option3");
                        elsAttachmentDtoList.addAll(option3);
                    }
                    if (fileType.containsKey("option4")) {
                        List<ElsAttachmentDto> option4 = fileType.get("option4");
                        elsAttachmentDtoList.addAll(option4);
                    }
                });
            }

            elsQuestionOptionDtoList.add(new ElsQuestionOptionDto(questionBank.getOption1(), 1, option1HasAttachment));
            elsQuestionOptionDtoList.add(new ElsQuestionOptionDto(questionBank.getOption2(), 2, option2HasAttachment));
            elsQuestionOptionDtoList.add(new ElsQuestionOptionDto(questionBank.getOption3(), 3, option3HasAttachment));
            elsQuestionOptionDtoList.add(new ElsQuestionOptionDto(questionBank.getOption4(), 4, option4HasAttachment));

            elsQuestionDto.setQuestionId(questionBank.getId());
            elsQuestionDto.setTitle(questionBank.getQuestion());
            elsQuestionDto.setType(mapAnswerType(questionBank.getQuestionTypeId()));
            elsQuestionDto.setQuestionLevel(questionBank.getEQuestionLevel().getTitleFa());
            elsQuestionDto.setCategoryId(questionBank.getCategoryId());
            elsQuestionDto.setSubCategory(questionBank.getSubCategoryId());
            elsQuestionDto.setOptionList(elsQuestionOptionDtoList);
            elsQuestionDto.setCorrectOption(questionBank.getMultipleChoiceAnswer());
            elsQuestionDto.setCorrectAnswer(questionBank.getDescriptiveAnswer());
            elsQuestionDto.setHasAttachment(questionHasAttachment);
            elsQuestionDto.setFiles(elsAttachmentDtoList);
//            elsQuestionDto.setDescription();
//            elsQuestionDto.setAnswerTime();

            elsQuestionDtoList.add(elsQuestionDto);
        });

        elsQuestionBankDto.setNationalCode(nationalCode);
        elsQuestionBankDto.setQuestions(elsQuestionDtoList);
        return elsQuestionBankDto;
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

}
