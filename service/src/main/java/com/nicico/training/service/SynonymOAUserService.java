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
}
