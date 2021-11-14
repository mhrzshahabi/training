package com.nicico.training.mapper.tclass;

import com.nicico.training.dto.TclassDTO;
import com.nicico.training.model.Tclass;
import org.mapstruct.*;
import response.tclass.dto.TclassDto;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface TclassBeanMapper {


    TclassDto toTclassResponse (Tclass tclass);
    TclassDTO.TClassCurrentTerm toTClassCurrentTerm (Tclass tclass);

}
