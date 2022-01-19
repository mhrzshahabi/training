package com.nicico.training.mapper.tclass;

import com.nicico.training.dto.TclassDTO;
import com.nicico.training.iservice.ITeacherService;
import com.nicico.training.model.TClassAudit;
import org.mapstruct.*;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public abstract class TclassAuditMapper {

    @Autowired
    private ITeacherService teacherService;

    @Mappings({
            @Mapping(source = "teacherId", target = "teacher",qualifiedByName = "getFullTeacher"),
    })
    abstract TclassDTO.InfoForAudit toDTO(TClassAudit tclass);
    public abstract List<TclassDTO.InfoForAudit> toTclassesResponse(List<TClassAudit> tclasss);

    abstract TclassDTO.InfoForEvalAudit toEvalAudit(TClassAudit tClass);
    public abstract List<TclassDTO.InfoForEvalAudit> toEvalAuditList(List<TClassAudit> tClass);

    @Named("getFullTeacher")
    String getFullTeacher(Long teacherId) {
        return teacherService.get(teacherId).getFullName();
    }

}
