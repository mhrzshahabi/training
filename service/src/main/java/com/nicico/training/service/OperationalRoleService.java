package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.core.SecurityUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CourseDTO;
import com.nicico.training.dto.OperationalRoleDTO;
import com.nicico.training.dto.ViewTrainingPostDTO;
import com.nicico.training.iservice.IDepartmentService;
import com.nicico.training.iservice.IOperationalRoleService;
import com.nicico.training.iservice.IPersonnelService;
import com.nicico.training.iservice.ITrainingPostService;
import com.nicico.training.mapper.course.CourseMapper;
import com.nicico.training.mapper.viewTrainingPost.ViewTrainingPostMapper;
import com.nicico.training.model.*;
import com.nicico.training.repository.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class OperationalRoleService implements IOperationalRoleService {

    private final ComplexDAO complexDAO;
    private final ModelMapper modelMapper;
    private final CourseMapper courseMapper;
    private final IPersonnelService personnelService;
    private ITrainingPostService trainingPostService;
    private final IDepartmentService departmentService;
    private final OperationalUnitDAO operationalUnitDAO;
    private final OperationalRoleDAO operationalRoleDAO;
    private final ViewTrainingPostDAO viewTrainingPostDAO;
    private final ViewTrainingPostMapper viewTrainingPostMapper;

    @Autowired
    public void setTrainingPostService(@Lazy ITrainingPostService trainingPostService) {
        this.trainingPostService = trainingPostService;
    }

    @Transactional
    @Override
    public OperationalRole create(OperationalRole creating) {
        try {
            Complex complex = complexDAO.getById(creating.getComplexId());
            String complexParameterCode = complex.getCode().trim().substring(0,3);
            OperationalUnit operationalUnit = operationalUnitDAO.findById(creating.getOperationalUnitId()).get();
            String generatedRoleCode = complexParameterCode + operationalUnit.getUnitCode();
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
    public List<OperationalRole> getOperationalRolesByByPostIdsAndComplexIdAndObjectType(Long postId, String objectType) {

        String complexTitle;
        Long complexId;
        Long departmentId = personnelService.getDepartmentIdByNationalCode(SecurityUtil.getNationalCode());
        if (departmentId != null) {
            complexTitle = departmentService.getComplexTitleById(departmentId);
            if (complexTitle == null) {
                complexTitle = "مدیر مجتمع مس سرچشمه";
            }
        } else {
            complexTitle = "مدیر مجتمع مس سرچشمه";
        }
        complexId = departmentService.getComplexIdByComplexTitle(complexTitle);

        List<OperationalRole> operationalRoles = operationalRoleDAO.findAllByPostIdsAndComplexIdAndObjectType(postId, complexId, objectType);
        if (operationalRoles.size() != 0)
            return operationalRoles;
        else return new ArrayList<>();
    }

    @Override
    public List<OperationalRole> getOperationalRolesByByComplexIdAndObjectType(String objectType) {

        String complexTitle;
        Long complexId;
        Long departmentId = personnelService.getDepartmentIdByNationalCode(SecurityUtil.getNationalCode());
        if (departmentId != null) {
            complexTitle = departmentService.getComplexTitleById(departmentId);
            if (complexTitle == null) {
                complexTitle = "مدیر مجتمع مس سرچشمه";
            }
        } else {
            complexTitle = "مدیر مجتمع مس سرچشمه";
        }
        complexId = departmentService.getComplexIdByComplexTitle(complexTitle);

        List<OperationalRole> operationalRoles = operationalRoleDAO.findAllByComplexIdAndObjectType(complexId, objectType);
        if (operationalRoles.size() != 0)
            return operationalRoles;
        else return new ArrayList<>();
    }

    @Override
    public List<String> getOperationalRoleTitlesByIds(List<Long> ids) {
        return operationalRoleDAO.findAllById(ids).stream().map(OperationalRole::getTitle).collect(Collectors.toList());
    }

    @Override
    public List<Long> getOperationalRoleUserIdsByIds(List<Long> ids) {
        return operationalRoleDAO.findAllById(ids).stream().map(OperationalRole::getUserIds).flatMap(Collection::stream).collect(Collectors.toList());
    }

    public Set<Long> getAllUserIdsByIds(List<Long> ids) {
        Set<Long> userIds = new HashSet<>();
        List<OperationalRole> operationalRoles = operationalRoleDAO.findAllById(ids);
        for (OperationalRole operationalRole : operationalRoles) {
            userIds.addAll(operationalRole.getUserIds());
        }
        return userIds;
    }

    @Override
    public List<Long> getAllUserIdsByComplexAndCategoryAndSubCategory(Long complexId, String objectType, Long categoryId, Long subCategoryId) {
        List<Long> operationalRoleIds = operationalRoleDAO.getOperationalRoleIdsByComplexIdAndSubCategoryId(complexId, objectType, subCategoryId);
        if (operationalRoleIds.size() == 0) {
            operationalRoleIds = operationalRoleDAO.getOperationalRoleIdsByComplexIdAndCategoryId(complexId, objectType, categoryId);
        }
        return operationalRoleIds;
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
        });

        savedOperationalRole.setPostIds(savedPostIds);
        return save(savedOperationalRole);
    }

    @Transactional
    @Override
    public List<CourseDTO.TupleInfo> addPostCodesToOperationalRole(Long roleId, List<String> postCodes) {
        List<String> returnPostCodes = new ArrayList<>();
        try {
            OperationalRole operationalRole = findById(roleId);
            Set<Long> postIds = operationalRole.getPostIds();

            postCodes.forEach(postCode -> {
                Optional<TrainingPost> optionalTrainingPost = trainingPostService.isTrainingPostExist(postCode);
                if (optionalTrainingPost.isPresent()) {
                    postIds.add(optionalTrainingPost.get().getId());
                } else
                    returnPostCodes.add(postCode);
            });
            operationalRole.setPostIds(postIds);
            save(operationalRole);
        } catch (Exception e) {
            throw new TrainingException(TrainingException.ErrorType.NotFound);
        }
        return courseMapper.toPostCodeDTOList(returnPostCodes);
    }

}
