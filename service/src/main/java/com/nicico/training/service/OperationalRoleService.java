package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.OperationalRoleDTO;
import com.nicico.training.dto.ViewTrainingPostDTO;
import com.nicico.training.iservice.IOperationalRoleService;
import com.nicico.training.mapper.viewTrainingPost.ViewTrainingPostMapper;
import com.nicico.training.model.Complex;
import com.nicico.training.model.OperationalRole;
import com.nicico.training.model.OperationalUnit;
import com.nicico.training.model.ViewTrainingPost;
import com.nicico.training.repository.ComplexDAO;
import com.nicico.training.repository.OperationalRoleDAO;
import com.nicico.training.repository.OperationalUnitDAO;
import com.nicico.training.repository.ViewTrainingPostDAO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class OperationalRoleService implements IOperationalRoleService {

    private final OperationalRoleDAO operationalRoleDAO;
    private final ViewTrainingPostDAO viewTrainingPostDAO;
    private final OperationalUnitDAO operationalUnitDAO;
    private final ComplexDAO complexDAO;
    private final ModelMapper modelMapper;
    private final ViewTrainingPostMapper viewTrainingPostMapper;

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
    public List<OperationalRole> getOperationalRolesByPostId(Long postId) {
        List<OperationalRole> operationalRoles = operationalRoleDAO.findAllByPostIds(postId);
        if (operationalRoles.size() != 0)
            return operationalRoles;
        else return new ArrayList<>();
    }

    @Override
    public List<String> getOperationalRoleTitlesByIds(List<Long> ids) {
        return operationalRoleDAO.findAllById(ids).stream().map(OperationalRole::getTitle).collect(Collectors.toList());
    }

    public Set<Long> getAllUserIdsByIds(List<Long> ids) {
        Set<Long> userIds = new HashSet<>();
        List<OperationalRole> operationalRoles = operationalRoleDAO.findAllById(ids);
        for (OperationalRole operationalRole : operationalRoles) {
            userIds.addAll(operationalRole.getUserIds());
        }
        return userIds;
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<OperationalRoleDTO.Info> deepSearch(SearchDTO.SearchRq searchRq) throws NoSuchFieldException, IllegalAccessException {
        SearchDTO.SearchRs<OperationalRoleDTO.Info> searchRs = BaseService.<OperationalRole, OperationalRoleDTO.Info, OperationalRoleDAO>optimizedSearch(operationalRoleDAO, p -> modelMapper.map(p, OperationalRoleDTO.Info.class), searchRq);
        return searchRs;
    }

    @Override
    public SearchDTO.SearchRs<ViewTrainingPostDTO.Info> getRoleUsedPostList(Long roleId) {
        List<ViewTrainingPost> viewTrainingPosts = viewTrainingPostDAO.getRoleUsedPostList(roleId);
        SearchDTO.SearchRs<ViewTrainingPostDTO.Info> rs = new SearchDTO.SearchRs<>();
        List<ViewTrainingPostDTO.Info> dtoList = new ArrayList<>();
        rs.setTotalCount((long) viewTrainingPosts.size());
        rs.setList(viewTrainingPostMapper.changeToViewTrainingPostDtoInfo(viewTrainingPosts, dtoList));
        return rs;
    }

    @Override
    public SearchDTO.SearchRs<ViewTrainingPostDTO.Info> getNonUsedRolePostList() {
        List<ViewTrainingPost> viewTrainingPosts = viewTrainingPostDAO.getNonUsedRolePostList();
        SearchDTO.SearchRs<ViewTrainingPostDTO.Info> rs = new SearchDTO.SearchRs<>();
        List<ViewTrainingPostDTO.Info> dtoList = new ArrayList<>();
        rs.setTotalCount((long) viewTrainingPosts.size());
        rs.setList(viewTrainingPostMapper.changeToViewTrainingPostDtoInfo(viewTrainingPosts, dtoList));
        return rs;
    }

    @Override
    public OperationalRole findById(Long id) {
        Optional<OperationalRole> operationalRole = operationalRoleDAO.findById(id);
        if (operationalRole.isEmpty()) {
            throw new TrainingException(TrainingException.ErrorType.NotFound, "نقش عملیاتی یافت نشد");
        }
        return operationalRole.get();
    }

    @Transactional
    @Override
    public OperationalRole save(OperationalRole operationalRole) {
        return operationalRoleDAO.save(operationalRole);
    }

    @Transactional
    @Override
    public void deleteIndividualPost(Long roleId, List<Long> postIds) {
        OperationalRole operationalRole = findById(roleId);
        Set<Long> savedPostIds = operationalRole.getPostIds();

        postIds.forEach(id -> {
            if (savedPostIds.stream().toList().contains(id)) {
                savedPostIds.remove(id);
            }
        });

        operationalRole.setPostIds(savedPostIds);
        save(operationalRole);
    }
    @Transactional
    @Override
    public OperationalRole addIndividualPost(Long roleId, List<Long> postIds) {
        OperationalRole savedOperationalRole = findById(roleId);
        Set<Long> savedPostIds = savedOperationalRole.getPostIds();

        postIds.forEach(id -> {
            if (!savedPostIds.stream().toList().contains(id)) {
                savedPostIds.add(id);
            }
//            else {
                //                throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
//            }
        });

        savedOperationalRole.setPostIds(savedPostIds);
        return save(savedOperationalRole);
    }

}
