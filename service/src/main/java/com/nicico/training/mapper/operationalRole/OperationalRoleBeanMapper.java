package com.nicico.training.mapper.operationalRole;

import com.nicico.training.dto.OperationalRoleDTO;
import com.nicico.training.model.OperationalRole;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

import java.util.List;

@Mapper(componentModel = "spring",unmappedTargetPolicy = ReportingPolicy.WARN)
public interface OperationalRoleBeanMapper {

    OperationalRole toOperationalRole(OperationalRoleDTO.Create request);

    OperationalRoleDTO.Info toOperationalRoleInfoDto(OperationalRole operationalRole);
    List<OperationalRoleDTO.Info> toOperationalRoleInfoDtoList(List<OperationalRole> operationalRoleList);

    OperationalRole toOperationalRoleFromOperationalRoleUpdateDto(OperationalRoleDTO.Update request);
    OperationalRole copyOperationalRoleFrom(OperationalRole operationalRole);
}
