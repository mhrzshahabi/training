package com.nicico.training.mapper.tclass;

import com.nicico.training.dto.ClassStudentHistoryDTO;

import com.nicico.training.iservice.IStudentService;
import com.nicico.training.iservice.ITclassService;
import com.nicico.training.model.ClassStudent;
import com.nicico.training.model.ClassStudentHistory;
import org.mapstruct.*;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public abstract class TclassStudentMapper {

    @Autowired
    private ITclassService iTclassService;
    @Autowired
    private IStudentService iStudentService;

    @Mappings({
            @Mapping(source = "tclassId", target = "code",qualifiedByName = "getClassCodeFromClassId"),
            @Mapping(source = "studentId", target = "student",qualifiedByName = "getStudentFromStudentId"),
    })
    abstract ClassStudentHistoryDTO.InfoForAudit toDTO(ClassStudentHistory tclass);
    public abstract List<ClassStudentHistoryDTO.InfoForAudit> toTclassesResponse(List<ClassStudentHistory> tclasss);


    @Mappings({
            @Mapping(source = "tclassId", target = "code",qualifiedByName = "getClassCodeFromClassId"),
            @Mapping(source = "studentId", target = "student",qualifiedByName = "getStudentFromStudentId"),
    })
    abstract ClassStudentHistoryDTO.InfoForAudit toClassStudentDTO(ClassStudent tclass);
    public abstract List<ClassStudentHistoryDTO.InfoForAudit> toTclassesStudentResponse(List<ClassStudent> tclasss);

    @Named("getClassCodeFromClassId")
    String getClassCodeFromClassId(Long classId) {
        try {
            return iTclassService.getTClass(classId).getCode();
        }catch (Exception e){
            return classId+"";
        }
    }
    @Named("getStudentFromStudentId")
    String getStudentFromStudentId(Long studentId) {
        try {
            return iStudentService.getStudent(studentId).getFirstName()+" "+iStudentService.getStudent(studentId).getLastName();
        }catch (Exception e){
            return studentId+"";
        }
    }

}
