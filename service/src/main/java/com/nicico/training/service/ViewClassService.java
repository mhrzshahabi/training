package com.nicico.training.service;

import com.nicico.training.dto.*;
import com.nicico.training.model.*;
import com.nicico.training.repository.*;;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;


@Slf4j
@Service
@RequiredArgsConstructor
public class ViewClassService extends BaseService<ViewClass, Long, ViewClassDTO, ViewClassDTO, ViewClassDTO, ViewClassDTO, ViewClassDAO> {


    @Autowired
    ViewClassService(ViewClassDAO viewClassDAO)  {
        super(new ViewClass(), viewClassDAO);
    }

    public List<Long> allClassHasMobileAlarm(){
        return dao.allClassHasMobileAlarm();
    }

}
