package com.nicico.training.mapper.question_protocol;

import com.nicico.training.model.QuestionProtocol;
import dto.exam.ElsImportedQuestionProtocol;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
import org.mapstruct.ReportingPolicy;

import java.util.List;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface QuestionProtocolMapper {

    @Mappings({
            @Mapping(source = "mark", target = "questionMark"),
            @Mapping(source = "question.id", target = "questionId")
    })
    QuestionProtocol toQuestionProtocol(ElsImportedQuestionProtocol elsImportedQuestionProtocol);

    @Mappings({
            @Mapping(source = "mark", target = "questionMark"),
            @Mapping(source = "question.id", target = "questionId")
    })
    List<QuestionProtocol> toQuestionProtocols(List<ElsImportedQuestionProtocol> elsImportedQuestionProtocol);


}
