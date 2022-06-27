package com.nicico.training.service;


import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CommitteeOfExpertsDTO;
import com.nicico.training.dto.CommitteeOfExpertsUsersDTO;
import com.nicico.training.dto.PersonnelRegisteredDTO;
import com.nicico.training.iservice.ICommitteeOfExpertsService;

import com.nicico.training.iservice.IPersonnelRegisteredService;
import com.nicico.training.iservice.ISynonymPersonnelService;
import com.nicico.training.model.CommitteeOfExperts;
import com.nicico.training.model.CommitteePersonnel;
import com.nicico.training.model.PersonnelRegistered;
import com.nicico.training.model.SynonymPersonnel;
import com.nicico.training.repository.CommitteeOfExpertsDAO;
import com.nicico.training.repository.CommitteePersonnelDAO;
import com.nicico.training.repository.PersonnelRegisteredDAO;
import com.nicico.training.repository.SynonymPersonnelDAO;
import lombok.RequiredArgsConstructor;

import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.BaseResponse;

import java.util.*;
import java.util.stream.Collectors;


@Service
@RequiredArgsConstructor
public class CommitteeOfExpertsService implements ICommitteeOfExpertsService {
    private final CommitteeOfExpertsDAO committeeDAO;
    private final CommitteePersonnelDAO committeePersonnelDAO;
    private final IPersonnelRegisteredService iPersonnelRegisteredService;
    private final ISynonymPersonnelService iSynonymPersonnelService;
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
    public BaseResponse addPart(CommitteeOfExpertsDTO.CreatePartOfPersons req) {
        BaseResponse baseResponse =new BaseResponse();

        try {
            CommitteeOfExperts committeeOfExperts=  get(req.getParentId());
            Set<CommitteePersonnel> personnels= new HashSet<>(committeePersonnelDAO.getAllByCommitteeOfExperts_Id(committeeOfExperts.getId()));
            CommitteePersonnel personnel =new CommitteePersonnel();
            personnel.setCommitteeOfExperts(committeeOfExperts);
            personnel.setRole(req.getRole());
            personnel.setCommitteeOfExpertId(committeeOfExperts.getId());
            personnel.setObjectId(req.getPersonnelId());
            personnel.setObjectType(req.getPersonnelType());
            if (personnels.stream().noneMatch(a->a.getObjectId().equals(personnel.getObjectId()) && a.getObjectType().equals(personnel.getObjectType()))){
                CommitteePersonnel savedPersonnel=  committeePersonnelDAO.save(personnel);
                personnels.add(savedPersonnel);
                committeeOfExperts.setCommitteePersonnels(personnels.stream().toList());
                create(committeeOfExperts);
            }
            baseResponse.setStatus(200);
            return baseResponse;
        }catch (Exception e){
            baseResponse.setStatus(400);
            return baseResponse;
        }

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
         Set<CommitteePersonnel> personnels= new HashSet<>(committeePersonnelDAO.getAllByCommitteeOfExperts_Id(id));
        List<CommitteeOfExpertsUsersDTO.Info> list=new ArrayList<>();
       for (CommitteePersonnel committeePersonnel : personnels){
           CommitteeOfExpertsUsersDTO.Info info= new CommitteeOfExpertsUsersDTO.Info();

           if (committeePersonnel.getObjectType().equals("registered")){
               PersonnelRegisteredDTO.Info  personnelRegisteredDTO= iPersonnelRegisteredService.get(committeePersonnel.getObjectId());
                  info.setFirstName(personnelRegisteredDTO.getFirstName());
                  info.setLastName(personnelRegisteredDTO.getLastName());
                  info.setNationalCode(personnelRegisteredDTO.getNationalCode());
                  info.setPersonnelNo(personnelRegisteredDTO.getPersonnelNo());
                  info.setPersonnelNo2(personnelRegisteredDTO.getPersonnelNo2());
                  info.setPhone(personnelRegisteredDTO.getPhone());
                  info.setPostTitle(personnelRegisteredDTO.getPostTitle());
                  info.setType("متفرقه");

           }else {
               SynonymPersonnel personnelRegisteredDTO= iSynonymPersonnelService.getById(committeePersonnel.getObjectId());
               info.setFirstName(personnelRegisteredDTO.getFirstName());
               info.setLastName(personnelRegisteredDTO.getLastName());
               info.setNationalCode(personnelRegisteredDTO.getNationalCode());
               info.setPersonnelNo(personnelRegisteredDTO.getPersonnelNo());
               info.setPersonnelNo2(personnelRegisteredDTO.getPersonnelNo2());
               info.setPhone(personnelRegisteredDTO.getPhone());
               info.setPostTitle(personnelRegisteredDTO.getPostTitle());
               info.setType("پرسنل");
           }
           info.setRole(committeePersonnel.getRole());
           list.add(info);
       }

        return list;
    }
}
