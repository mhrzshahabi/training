package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.OperationalRoleDTO;
import com.nicico.training.iservice.IOperationalRoleService;
import com.nicico.training.mapper.operationalRole.OperationalRoleBeanMapper;
import com.nicico.training.model.*;
import com.nicico.training.repository.ComplexDAO;
import com.nicico.training.repository.OperationalRoleDAO;
import com.nicico.training.repository.OperationalUnitDAO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.hibernate.exception.ConstraintViolationException;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.Random;

@Slf4j
@Service
@RequiredArgsConstructor
public class OperationalRoleService implements IOperationalRoleService {

    private final OperationalRoleDAO operationalRoleDAO;
    private final OperationalUnitDAO operationalUnitDAO;
    private final ComplexDAO complexDAO;
    private final OperationalRoleBeanMapper mapper;

    @Transactional
    @Override
    public OperationalRoleDTO.Info create(OperationalRoleDTO.Create request) {
        try {
            Complex complex = complexDAO.getOne(request.getComplexId());
            String complexParameterCode = complex.getCode().trim().substring(0,3);
            OperationalUnit operationalUnit = operationalUnitDAO.findById(request.getOperationalUnitId()).get();
            String generatedRoleCode = complexParameterCode + operationalUnit.getUnitCode();
            OperationalRole creating = mapper.toOperationalRole(request);
//            creating.setOperationalUnit(operationalUnit);
            Random rand = new Random();
            String random4Code = String.format("%04d", rand.nextInt(10000));
            String finalCode = generatedRoleCode + random4Code;
            while (operationalRoleDAO.existsOperationalRoleByCode(finalCode)){
                random4Code = String.format("%04d", rand.nextInt(10000));
                finalCode = generatedRoleCode + random4Code;
            }
            creating.setCode(finalCode);
            return mapper.toOperationalRoleInfoDto(operationalRoleDAO.save(creating));
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Override
    public List<Long> getUsedPostIdsInRoles() {
//        if (roleId == null){
//            roleId = 0L;
//        }
        List<Long> usedPostIds = operationalRoleDAO.getUsedPostIdsInRoles();
        return usedPostIds;
    }


    @Override
    public SearchDTO.SearchRs<OperationalRoleDTO.Info> search(SearchDTO.SearchRq searchRq) {
        return SearchUtil.search(operationalRoleDAO, searchRq, job -> mapper.toOperationalRoleInfoDto(job));

    }

    @Transactional
    @Override
    public OperationalRoleDTO.Info update(Long id, OperationalRoleDTO.Update request) {
        final OperationalRole operationalRole = getOperationalRole(id);
        OperationalRole updating = new OperationalRole();
        updating = mapper.copyOperationalRoleFrom(operationalRole);
        updating.setUserIds(request.getUserIds());
        try {
            return mapper.toOperationalRoleInfoDto(operationalRoleDAO.save(updating));
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional(readOnly = true)
    public OperationalRole getOperationalRole(Long id) {
        Optional<OperationalRole> operationalRole = operationalRoleDAO.findById(id);
        return operationalRole.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
    }
}
