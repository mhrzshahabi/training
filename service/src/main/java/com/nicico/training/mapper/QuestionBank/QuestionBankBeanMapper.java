package com.nicico.training.mapper.QuestionBank;


import com.nicico.training.dto.question.QuestionAttachments;
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
import java.util.Optional;


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

            QuestionAttachments attachments = attachmentService.getFiles("QuestionBank", questionBank.getId());
            if (attachments != null) {
                List<Map<String, String>> files = attachments.getFiles();
                List<Map<String, String>> option1Files = attachments.getOption1Files();
                List<Map<String, String>> option2Files = attachments.getOption2Files();
                List<Map<String, String>> option3Files = attachments.getOption3Files();
                List<Map<String, String>> option4Files = attachments.getOption4Files();

                if (files.size() != 0 )
                    questionHasAttachment = true;
                if (option1Files.size() != 0)
                    option1HasAttachment = true;
                if (option2Files.size() != 0)
                    option2HasAttachment = true;
                if (option3Files.size() != 0)
                    option3HasAttachment = true;
                if (option4Files.size() != 0)
                    option4HasAttachment = true;

                files.forEach(file -> {
                    Map.Entry<String, String> map = file.entrySet().stream().findFirst().get();
                    ElsAttachmentDto elsAttachmentDto = new ElsAttachmentDto(map.getKey(), map.getValue());
                    elsAttachmentDtoList.add(elsAttachmentDto);
                });
                option1Files.forEach(option1 -> {
                    Optional<Map.Entry<String, String>> map = option1.entrySet().stream().findFirst();
                    if (map.isPresent()) {
                        ElsAttachmentDto elsAttachmentDto = new ElsAttachmentDto(map.get().getKey(), map.get().getValue());
                        elsAttachmentDtoList.add(elsAttachmentDto);
                    }
                });
                option2Files.forEach(option2 -> {
                    Optional<Map.Entry<String, String>> map = option2.entrySet().stream().findFirst();
                    ElsAttachmentDto elsAttachmentDto = new ElsAttachmentDto(map.get().getKey(), map.get().getValue());
                    elsAttachmentDtoList.add(elsAttachmentDto);
                });
                option3Files.forEach(option3 -> {
                    Optional<Map.Entry<String, String>> map = option3.entrySet().stream().findFirst();
                    ElsAttachmentDto elsAttachmentDto = new ElsAttachmentDto(map.get().getKey(), map.get().getValue());
                    elsAttachmentDtoList.add(elsAttachmentDto);
                });
                option4Files.forEach(option4 -> {
                    Optional<Map.Entry<String, String>> map = option4.entrySet().stream().findFirst();
                    ElsAttachmentDto elsAttachmentDto = new ElsAttachmentDto(map.get().getKey(), map.get().getValue());
                    elsAttachmentDtoList.add(elsAttachmentDto);
                });
            }

            elsQuestionOptionDtoList.add(new ElsQuestionOptionDto(questionBank.getOption1(), 1, option1HasAttachment));
            elsQuestionOptionDtoList.add(new ElsQuestionOptionDto(questionBank.getOption2(), 2, option2HasAttachment));
            elsQuestionOptionDtoList.add(new ElsQuestionOptionDto(questionBank.getOption3(), 3, option3HasAttachment));
            elsQuestionOptionDtoList.add(new ElsQuestionOptionDto(questionBank.getOption4(), 4, option4HasAttachment));

            elsQuestionDto.setTitle(questionBank.getQuestion());
            elsQuestionDto.setType(mapAnswerType(questionBank.getQuestionTypeId()));
            elsQuestionDto.setQuestionLevel(mapQuestionLevel(questionBank.getEQuestionLevel().getTitleFa()));
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
        elsQuestionBankDto.setQuestion(elsQuestionDtoList);
        return elsQuestionBankDto;
    }

    protected EQuestionType mapAnswerType(Long answerTypeId) {

        String answerTypeCode = parameterValueService.getParameterValueCodeById(answerTypeId);
        switch (answerTypeCode) {
            case "MultipleChoiceAnswer":
                return EQuestionType.MULTI_CHOICES;
            case "Descriptive":
                return EQuestionType.DESCRIPTIVE;
            default:
                return null;
        }
    }

    protected ElsQuestionLevel mapQuestionLevel(String title) {

        switch (title) {
            case "آسان":
                return ElsQuestionLevel.EASY;
            case "متوسط":
                return ElsQuestionLevel.MODERATE;
            case "سخت":
                return ElsQuestionLevel.DIFFICULT;
            default:
                return null;
        }
    }

}
