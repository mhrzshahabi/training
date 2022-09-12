package com.nicico.training.service;

import com.nicico.training.iservice.ISynonymOAUserService;
import com.nicico.training.model.SynonymOAUser;
import com.nicico.training.repository.SynonymOAUserDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class SynonymOAUserService implements ISynonymOAUserService {

    private final SynonymOAUserDAO synonymOAUserDAO;

    @Override
    public String getNationalCodeByUserId(Long userId) {
        Optional<SynonymOAUser> optionalSynonymOAUser = synonymOAUserDAO.findById(userId);
        return optionalSynonymOAUser.map(SynonymOAUser::getNationalCode).orElse(null);
    }

    @Override
    public String getFullNameByNationalCode(String nationalCode) {
        Optional<SynonymOAUser> optionalSynonymOAUser = synonymOAUserDAO.findByNationalCode(nationalCode);
        return optionalSynonymOAUser.map(synonymOAUser -> synonymOAUser.getFirstName() + " " + synonymOAUser.getLastName()).orElse(nationalCode);
    }

    @Override
    public String getFullNameByUserId(Long userId) {
        Optional<SynonymOAUser> optionalSynonymOAUser = synonymOAUserDAO.findById(userId);

           String firstName = optionalSynonymOAUser.map(SynonymOAUser::getFirstName).orElse(null);
           String lastName = optionalSynonymOAUser.map(SynonymOAUser::getLastName).orElse(null);

           if (firstName !=null && lastName ==null) {
               return firstName;
           }
        if (firstName ==null && lastName !=null) {
            return lastName;
        }

        return  (firstName + " " + lastName).compareTo("null null") == 0 ? null : firstName + " " + lastName;
    }

}
