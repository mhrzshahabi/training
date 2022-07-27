package com.nicico.training.service;


import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.*;

import com.nicico.training.model.*;
import com.nicico.training.repository.*;
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
    private final CommitteePostDAO committeePostDAO;
    private final IPersonnelRegisteredService iPersonnelRegisteredService;
      private final ITrainingPostService iTrainingPostService;
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
    public BaseResponse addPartOfPersonnel(CommitteeOfExpertsDTO.CreatePartOfPersons req) {
        BaseResponse baseResponse =new BaseResponse();

        try {
            CommitteeOfExperts committeeOfExperts=  get(req.getParentId());
            Set<CommitteePersonnel> personnels= new HashSet<>(committeePersonnelDAO.getAllByCommitteeOfExperts_Id(committeeOfExperts.getId()));
            if (personnels.stream().noneMatch(a->a.getPosition().equals(req.getPosition()) && req.getPosition().equals("رئيس و هماهنگ کننده کميته"))){
                CommitteePersonnel personnel =new CommitteePersonnel();
                personnel.setCommitteeOfExperts(committeeOfExperts);
                personnel.setRole(req.getRole());
                personnel.setPosition(req.getPosition());
                personnel.setCommitteeOfExpertId(committeeOfExperts.getId());
                personnel.setObjectId(req.getPersonnelId());
                personnel.setObjectType(req.getPersonnelType());
                if (personnels.stream().noneMatch(a->a.getObjectId().equals(personnel.getObjectId()) && a.getObjectType().equals(personnel.getObjectType()))){
                    CommitteePersonnel savedPersonnel=  committeePersonnelDAO.save(personnel);
                    personnels.add(savedPersonnel);
                    committeeOfExperts.setCommitteePersonnels(personnels.stream().toList());
                    create(committeeOfExperts);
                }else{
                    baseResponse.setStatus(400);
                    baseResponse.setMessage("این فرد قبلا اضافه شده است");
                    return baseResponse;
                }
                baseResponse.setStatus(200);
                return baseResponse;
            }else {
                baseResponse.setStatus(400);
                baseResponse.setMessage("این کمیته در حال حاضر یک رئيس دارد");
                return baseResponse;
            }

        }catch (Exception e){
            baseResponse.setStatus(400);
            baseResponse.setMessage("خطا در اضافه کردن فرد به کمیته");

            return baseResponse;
        }

    }
    @Override
    public BaseResponse addPartOfPost(CommitteeOfExpertsDTO.CreatePartOfPosts req) {
        BaseResponse baseResponse =new BaseResponse();

        try {
            CommitteeOfExperts committeeOfExperts=  get(req.getParentId());
            Set<CommitteePost> posts= new HashSet<>(committeePostDAO.getAllByCommitteeOfExperts_Id(committeeOfExperts.getId()));
            CommitteePost post =new CommitteePost();
            post.setCommitteeOfExperts(committeeOfExperts);
            post.setCommitteeOfExpertId(committeeOfExperts.getId());
            post.setPostId(req.getPostId());
            post.setPostCode(req.getPostCode());
            post.setPostType(req.getPostType());
            if (posts.stream().noneMatch(a->a.getPostId().equals(post.getPostId()) && a.getPostType().equals(post.getPostType()))){
                CommitteePost savedPost=  committeePostDAO.save(post);
                posts.add(savedPost);
                committeeOfExperts.setCommitteePosts(posts.stream().toList());
                create(committeeOfExperts);
            }else {
                baseResponse.setStatus(400);
                baseResponse.setMessage("این پست قبلا اضافه شده است");
                return baseResponse;

            }
            baseResponse.setStatus(200);
            return baseResponse;
        }catch (Exception e){
            baseResponse.setStatus(400);
            baseResponse.setMessage("خطا در اضافه کردن پست به کمیته");

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
        getItem.setComplexes(committeeOfExperts.getComplexes());
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
           if (personnelRegisteredDTO!=null){
               info.setFirstName(personnelRegisteredDTO.getFirstName());
               info.setLastName(personnelRegisteredDTO.getLastName());
               info.setNationalCode(personnelRegisteredDTO.getNationalCode());
               info.setPersonnelNo(personnelRegisteredDTO.getPersonnelNo());
               info.setPersonnelNo2(personnelRegisteredDTO.getPersonnelNo2());
               info.setPhone(personnelRegisteredDTO.getPhone());
               info.setPostTitle(personnelRegisteredDTO.getPostTitle());
               info.setType("پرسنل");
           }

           }
           info.setRole(committeePersonnel.getRole());
           info.setPosition(committeePersonnel.getPosition());
           info.setId(committeePersonnel.getId());
           list.add(info);
       }

        return list;
    }

    @Override
    public void deletePartOfPersonnel(Long parentId, Long childId) {
        try {
            if (committeeDAO.existsById(parentId) && committeePersonnelDAO.existsById(childId)) {
                committeePersonnelDAO.deleteById(childId);
            }
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }
    }


    @Override
    public List<CommitteeOfExpertsPostDTO.Info> listOfPost(Long id) {
        Set<CommitteePost> posts= new HashSet<>(committeePostDAO.getAllByCommitteeOfExperts_Id(id));
        List<CommitteeOfExpertsPostDTO.Info> list=new ArrayList<>();
        for (CommitteePost committeePersonnel : posts){
            CommitteeOfExpertsPostDTO.Info info= new CommitteeOfExpertsPostDTO.Info();

            if (committeePersonnel.getPostType().equals("post")){
                Optional<SynonymPersonnel> optionalSynonymPersonnel =   iSynonymPersonnelService.getByPostCode(committeePersonnel.getPostCode());
                if (optionalSynonymPersonnel.isPresent()){
                    SynonymPersonnel personnel=optionalSynonymPersonnel.get();
                    info.setUserNationalCode(personnel.getNationalCode());
                    info.setPhone(personnel.getPhone());
                    info.setUserName(personnel.getFirstName() + " "+personnel.getLastName());

                }
                info.setObjectCode(committeePersonnel.getPostCode());
                info.setObjectType("پست انفرادی");

            }else  if (committeePersonnel.getPostType().equals("training_Post")){

                info.setObjectCode(committeePersonnel.getPostCode());
                info.setObjectType("پست");
            }else  if (committeePersonnel.getPostType().equals("group_Post")){

                info.setObjectCode(committeePersonnel.getPostCode());
                info.setObjectType("گروه پستی");
            }
            info.setId(committeePersonnel.getId());
            list.add(info);
        }

        return list;
    }

    @Override
    public void deletePartOfPosts(Long parentId, Long childId) {
        try {
            if (committeeDAO.existsById(parentId) && committeePostDAO.existsById(childId)) {
                committeePostDAO.deleteById(childId);
            }
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
        }

    }

}
