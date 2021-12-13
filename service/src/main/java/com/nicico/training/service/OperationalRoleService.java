package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AccountInfoDTO;
import com.nicico.training.dto.OperationalRoleDTO;
import com.nicico.training.dto.TeacherDTO;
import com.nicico.training.iservice.IOperationalRoleService;
import com.nicico.training.mapper.operationalRole.OperationalRoleBeanMapper;
import com.nicico.training.model.*;
import com.nicico.training.repository.ComplexDAO;
import com.nicico.training.repository.OperationalRoleDAO;
import com.nicico.training.repository.OperationalUnitDAO;
import com.nicico.training.repository.TeacherDAO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.Random;
import java.util.Set;

@Slf4j
@Service
@RequiredArgsConstructor
public class OperationalRoleService implements IOperationalRoleService {

    private final OperationalRoleDAO operationalRoleDAO;
    private final OperationalUnitDAO operationalUnitDAO;
    private final ComplexDAO complexDAO;
    private final ModelMapper modelMapper;

    @Transactional
    @Override
    public OperationalRole create(OperationalRole creating) {
        try {
            Complex complex = complexDAO.getById(creating.getComplexId());
            String complexParameterCode = complex.getCode().trim().substring(0,3);
            OperationalUnit operationalUnit = operationalUnitDAO.findById(creating.getOperationalUnitId()).get();
            String generatedRoleCode = complexParameterCode + operationalUnit.getUnitCode();
//            creating.setOperationalUnit(operationalUnit);
            Random rand = new Random();
            String random4Code = String.format("%04d", rand.nextInt(10000));
            String finalCode = generatedRoleCode + random4Code;
            while (operationalRoleDAO.existsOperationalRoleByCode(finalCode)){
                random4Code = String.format("%04d", rand.nextInt(10000));
                finalCode = generatedRoleCode + random4Code;
            }
            creating.setCode(finalCode);
            return operationalRoleDAO.save(creating);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Override
    public List<Long> getUsedPostIdsInRoles(Long roleId) {
        if (roleId == null){
            roleId = 0L;
        }
        List<Long> usedPostIds = operationalRoleDAO.getUsedPostIdsInRoles(roleId);
        return usedPostIds;
    }

    @Override
    public List<Long> getUserAccessPostsInRole(Long userId) {
        if (userId!= null){
          return  operationalRoleDAO.getUserAccessPostsInRole(userId);
        } else return null;
    }

    @Override
    public Set<Long> getUserAccessTrainingPostsInRole(Long userId) {
        if (userId!= null){
            return  operationalRoleDAO.getUserAccessTrainingPostsInRole(userId);
        } else return null;
    }


    @Override
    public SearchDTO.SearchRs<OperationalRoleDTO.Info> search(SearchDTO.SearchRq searchRq) {
        return SearchUtil.search(operationalRoleDAO, searchRq, role -> modelMapper.map(role, OperationalRoleDTO.Info.class));

    }

    @Transactional
    @Override
    public OperationalRole update(Long id, OperationalRole updating) {
        try {
            return operationalRoleDAO.save(updating);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public void deleteAll(List<Long> request) {
        final List<OperationalRole> gAllById = operationalRoleDAO.findAllById(request);
        operationalRoleDAO.deleteAll(gAllById);
    }

    @Transactional(readOnly = true)
    public OperationalRole getOperationalRole(Long id) {
        Optional<OperationalRole> operationalRole = operationalRoleDAO.findById(id);
        return operationalRole.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
    }

    @Override
    public String getWorkGroup(Long postId) {
         Optional<OperationalRole> operationalRole = operationalRoleDAO.findByPostIds(postId);
         if (operationalRole.isPresent())
             return operationalRole.get().getTitle();
         else return "گروه کاری ثبت نشده";
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<OperationalRoleDTO.Info> deepSearch(SearchDTO.SearchRq searchRq) throws NoSuchFieldException, IllegalAccessException {
        SearchDTO.SearchRs<OperationalRoleDTO.Info> searchRs = BaseService.<OperationalRole, OperationalRoleDTO.Info, OperationalRoleDAO>optimizedSearch(operationalRoleDAO, p -> modelMapper.map(p, OperationalRoleDTO.Info.class), searchRq);
        return searchRs;
    }

}
