package com.nicico.training.service;


import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.GroupOfPersonnelDTO;
import com.nicico.training.iservice.IGroupOfPersonnelService;
import com.nicico.training.model.GroupOfPersonnel;
import com.nicico.training.model.Personnel;
import com.nicico.training.repository.GroupOfPersonnelDAO;
import com.nicico.training.repository.PersonnelDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.BaseResponse;
import response.exam.ResendExamTimes;

import java.util.List;
import java.util.Optional;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class GroupOfPersonnelService implements IGroupOfPersonnelService {


    private final ModelMapper modelMapper;
    private final GroupOfPersonnelDAO groupOfPersonnelDao;
    private final PersonnelDAO personnelDAO;

    @Transactional
    @Override
    public BaseResponse create(GroupOfPersonnelDTO.Create request) {
        BaseResponse response = new ResendExamTimes();
        Optional<GroupOfPersonnel> optionalGroupOfPersonnel = groupOfPersonnelDao.findFirstByCode(request.getCode());
        if (optionalGroupOfPersonnel.isPresent()) {
            response.setMessage("امکان ایجاد گروه با کد تکراری وجود ندارد .");
            response.setStatus(406);
        } else {
            final GroupOfPersonnel groupOfPersonnel = modelMapper.map(request, GroupOfPersonnel.class);
            try {
                groupOfPersonnelDao.save(groupOfPersonnel);
                response.setStatus(200);
            } catch (Exception e) {
                response.setMessage("عملیات انجام نشد .");
                response.setStatus(404);
            }
            ;
        }

        return response;
    }

    @Transactional
    @Override
    public BaseResponse update(Long id, GroupOfPersonnelDTO.Update request) {
        BaseResponse response = new ResendExamTimes();

        final Optional<GroupOfPersonnel> cById = groupOfPersonnelDao.findById(id);
        if (cById.isEmpty()) {
            response.setMessage("تیم وجود ندارد .");
            response.setStatus(406);
        } else {
            try {
                GroupOfPersonnel updating = new GroupOfPersonnel();
                modelMapper.map(cById.get(), updating);
                modelMapper.map(request, updating);
                Optional<GroupOfPersonnel> optionalGroupOfPersonnel = groupOfPersonnelDao.findFirstByCode(updating.getCode());
                if (optionalGroupOfPersonnel.isPresent() && !optionalGroupOfPersonnel.get().getId().equals(id) ) {
                    response.setMessage("امکان ایجاد گروه با کد تکراری وجود ندارد .");
                    response.setStatus(406);
                } else {
                    groupOfPersonnelDao.save(updating);
                    response.setStatus(200);
                }
            } catch (Exception e) {
                response.setMessage("عملیات انجام نشد .");
                response.setStatus(404);
            }
            ;
        }
        return response;
    }

    //
    @Transactional
    @Override
    public BaseResponse delete(Long id) {
        BaseResponse response = new ResendExamTimes();

        try {
            groupOfPersonnelDao.deleteById(id);
            response.setStatus(200);
        } catch (Exception e) {
            response.setMessage("عملیات انجام نشد .");
            response.setStatus(404);
        }
        return response;

    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<GroupOfPersonnelDTO.Info> searchWithoutPermission(SearchDTO.SearchRq request) {
        return SearchUtil.search(groupOfPersonnelDao, request, group -> modelMapper.map(group, GroupOfPersonnelDTO.Info.class));
    }

    @Override
    public List<Long> getPersonnel(Long id) {
        final GroupOfPersonnel groupOfPersonnel = groupOfPersonnelDao.findById(id).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));
        return groupOfPersonnelDao.getAllPersonnelByGroupId(groupOfPersonnel.getId());
    }

    @Override
    public GroupOfPersonnel get(Long id) {
        return groupOfPersonnelDao.findById(id).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));
    }

    @Override
    @Transactional
    public void addPersonnel(Long groupId, Set<Long> ids) {
        final Optional<GroupOfPersonnel> optionalGroupOfPersonnel = groupOfPersonnelDao.findById(groupId);
        final GroupOfPersonnel groupOfPersonnel = optionalGroupOfPersonnel.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));

        Set<Personnel> personnelSet = groupOfPersonnel.getPersonnelSet();

        for (Long id : ids) {

            final Optional<Personnel> optionalPersonnel = personnelDAO.findById(id);
            final Personnel personnel = optionalPersonnel.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostNotFound));
            personnelSet.add(personnel);
        }
        groupOfPersonnel.setPersonnelSet(personnelSet);
    }
    @Override
    @Transactional
    public void removePersonnel(Long groupId, Set<Long> ids) {
        final Optional<GroupOfPersonnel> optionalGroupOfPersonnel = groupOfPersonnelDao.findById(groupId);
        final GroupOfPersonnel groupOfPersonnel = optionalGroupOfPersonnel.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostGroupNotFound));

        Set<Personnel> personnelSet = groupOfPersonnel.getPersonnelSet();

        for (Long id : ids) {

            final Optional<Personnel> optionalPersonnel = personnelDAO.findById(id);
            final Personnel personnel = optionalPersonnel.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostNotFound));
            personnelSet.remove(personnel);
        }
        groupOfPersonnel.setPersonnelSet(personnelSet);
    }
}
