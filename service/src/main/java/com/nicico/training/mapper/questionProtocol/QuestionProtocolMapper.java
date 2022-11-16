package com.nicico.training.mapper.questionProtocol;

import com.nicico.training.model.QuestionProtocol;
import dto.exam.ImportedQuestionProtocol;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
import org.mapstruct.ReportingPolicy;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface QuestionProtocolMapper {

    @Mappings({
            @Mapping(target = "questionId", source = "question.id"),
            @Mapping(target = "questionMark", source = "mark"),
            @Mapping(target = "questionTitle", source = "question.title"),
            @Mapping(target = "questionType", source = "question.type")
    })
    QuestionProtocol toQuestionProtocol(ImportedQuestionProtocol importedQuestionProtocol);


}
