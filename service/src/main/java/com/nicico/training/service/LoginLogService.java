package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.LoginLogDTO;
import com.nicico.training.iservice.ILoginLogService;
import com.nicico.training.repository.LoginLogDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class LoginLogService implements ILoginLogService {

    private final LoginLogDAO loginLogDAO;
    private final ModelMapper modelMapper;

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<LoginLogDTO> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(loginLogDAO, request, loginLog -> modelMapper.map(loginLog, LoginLogDTO.class));
    }
}
