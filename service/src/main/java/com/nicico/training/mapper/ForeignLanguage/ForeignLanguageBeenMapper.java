package com.nicico.training.mapper.ForeignLanguage;

import com.nicico.training.dto.ForeignLangKnowledgeDTO;
import com.nicico.training.model.ForeignLangKnowledge;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.ReportingPolicy;

import java.util.List;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public abstract class ForeignLanguageBeenMapper {
    @Mapping(source = "langName",target = "title")
    @Mapping(source = "langLevel.titleFa",target = "level")
    @Mapping(source = "instituteName",target = "instituteName")
    @Mapping(source = "duration",target = "duration")
    @Mapping(source = "startDate",target = "from")
    @Mapping(source = "endDate",target = "to")
    public abstract ForeignLangKnowledgeDTO.Resume toDTO(ForeignLangKnowledge foreignLangKnowledge);
    public abstract List<ForeignLangKnowledgeDTO.Resume> toDTOs(List<ForeignLangKnowledge> foreignLangKnowledgeList);
}
