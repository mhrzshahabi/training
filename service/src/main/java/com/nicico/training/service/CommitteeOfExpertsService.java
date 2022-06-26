package com.nicico.training.service;


import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CommitteeOfExpertsDTO;
import com.nicico.training.dto.CommitteeOfExpertsUsersDTO;
import com.nicico.training.iservice.ICommitteeOfExpertsService;

import com.nicico.training.model.CommitteeOfExperts;
import com.nicico.training.model.CommitteePersonnel;
import com.nicico.training.repository.CommitteeOfExpertsDAO;
import com.nicico.training.repository.CommitteePersonnelDAO;
import lombok.RequiredArgsConstructor;

import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import response.BaseResponse;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;


@Service
@RequiredArgsConstructor
public class CommitteeOfExpertsService implements ICommitteeOfExpertsService {
    private final CommitteeOfExpertsDAO committeeDAO;
    private final CommitteePersonnelDAO committeePersonnelDAO;
       private final ModelMapper mapper;

    @Override
    public SearchDTO.SearchRs<CommitteeOfExpertsDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(committeeDAO, request, committee -> mapper.map(committee, CommitteeOfExpertsDTO.Info.class));

    }

    @Override
    public BaseResponse create(CommitteeOfExperts request) {
        BaseResponse response=new BaseResponse();
        try {
            committeeDAO.save(request);
            response.setStatus(200);
        }catch (Exception e){
            response.setStatus(406);
        }
        return response;
    }

    @Override
    public void delete(Long id) {
        try {
            if (committeeDAO.existsById(id)) {
                committeeDAO.deleteById(id);
            }
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }

    @Override
    public CommitteeOfExperts get(Long id) {
        Optional<CommitteeOfExperts> committeeOfExperts = committeeDAO.findById(id);
        return committeeOfExperts.orElse(null);
    }

    @Override
    public BaseResponse edit(CommitteeOfExperts committeeOfExperts) {
        CommitteeOfExperts getItem = get(committeeOfExperts.getId());
        getItem.setComplex(committeeOfExperts.getComplex());
        getItem.setAddress(committeeOfExperts.getAddress());
        getItem.setEmail(committeeOfExperts.getEmail());
        getItem.setFax(committeeOfExperts.getFax());
        getItem.setPhone(committeeOfExperts.getPhone());
        getItem.setTitle(committeeOfExperts.getTitle());
        return create(getItem);
    }

    @Override
    public List<CommitteeOfExpertsUsersDTO.Info> listOfParts(Long id) {
//        CommitteeOfExperts getItem = get(id);
        List<CommitteePersonnel> personnels= committeePersonnelDAO.findAll();
        List<CommitteeOfExpertsUsersDTO.Info> list=new ArrayList<>();
       for (CommitteePersonnel committeePersonnel : personnels){
           CommitteeOfExpertsUsersDTO.Info info= new CommitteeOfExpertsUsersDTO.Info();
           info.setId(committeePersonnel.getPersonnel().getId());
           info.setFirstName(committeePersonnel.getPersonnel().getFirstName());
           info.setLastName(committeePersonnel.getPersonnel().getLastName());
           info.setPersonnelNo(committeePersonnel.getPersonnel().getPersonnelNo());
           info.setPersonnelNo2(committeePersonnel.getPersonnel().getPersonnelNo2());
           info.setNationalCode(committeePersonnel.getPersonnel().getNationalCode());
           info.setType("پرسنل");
           info.setPhone(committeePersonnel.getPersonnel().getPhone());
           info.setPostTitle(committeePersonnel.getPersonnel().getPostTitle());
           info.setRole(committeePersonnel.getRole());
           list.add(info);
       }

        return list;
    }
}
