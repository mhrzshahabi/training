package com.nicico.training.mapper.tclass;

import com.nicico.training.dto.TclassDTO;
import com.nicico.training.model.Tclass;
import com.nicico.training.model.Teacher;
import com.nicico.training.model.enums.ERunType;
import org.mapstruct.*;
import response.tclass.dto.TclassDto;

import java.util.List;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface TclassBeanMapper {


    TclassDto toTclassResponse (Tclass tclass);

}
