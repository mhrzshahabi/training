package com.nicico.training.mapper.testQuestion;

import com.nicico.training.dto.TestQuestionDTO;
import com.nicico.training.model.TestQuestion;
import dto.exam.ElsExamCreateDTO;
import dto.exam.ElsImportedExam;
import dto.exam.ExamNotSentToElsDTO;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
import org.mapstruct.ReportingPolicy;

import java.util.List;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface TestQuestionMapper {

    @Mappings({
            @Mapping(target = "date", source = "startDate"),
            @Mapping(target = "time", source = "startTime"),
            @Mapping(target = "classCode", source = "examCode")
    })
    TestQuestionDTO.Import toTestQuestionDto(ElsImportedExam elsImportedExam);

    @Mappings({
            @Mapping(target = "startDate", source = "date"),
            @Mapping(target = "startTime", source = "time"),
            @Mapping(target = "sourceExamId", source = "id")
    })
    ElsExamCreateDTO.Info toInfo(TestQuestionDTO.Info info);

    @Mappings({
            @Mapping(target = "startDate", source = "date"),
            @Mapping(target = "startTime", source = "time"),
            @Mapping(target = "sourceExamId", source = "id")
    })
    ElsExamCreateDTO.Info toInfo(TestQuestion testQuestion);

    TestQuestionDTO.Create toCreate(TestQuestionDTO.Import dto);

    ExamNotSentToElsDTO.Info toExamNotSentDto(TestQuestion testQuestion);

    List<ExamNotSentToElsDTO.Info> toExamNotSentDto(List<TestQuestion> testQuestions);

}
