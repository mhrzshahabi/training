package com.nicico.training.service;

import com.nicico.training.dto.TargetSocietyDTO;
import com.nicico.training.model.TargetSociety;
import com.nicico.training.repository.TargetSocietyDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class TargetSocietyService extends BaseService<TargetSociety, Long, TargetSocietyDTO.Info, TargetSocietyDTO.Create, TargetSocietyDTO.Update, TargetSocietyDTO.Delete, TargetSocietyDAO> {

    @Autowired
    TargetSocietyService(TargetSocietyDAO targetSocietyDAO) {
        super(new TargetSociety(), targetSocietyDAO);
    }

    @Transactional
    public List<TargetSocietyDTO.Info> coustomListCreate(List<Object> societies, Long typeId, Long tclassId){
        List<TargetSocietyDTO.Info> result = new ArrayList<>();

        for(Object society : societies){
            TargetSocietyDTO.Create create = new TargetSocietyDTO.Create();
            if(typeId == 1)
                create.setSocietyId(((Integer) society).longValue());
            else if(typeId == 2)
                create.setTitle((String) society);
            create.setTargetSocietyTypeId(new Long(214));
            create.setTclassId(tclassId);
            result.add(super.create(create));
        }

        return result;
    }

    @Transactional
    public List<TargetSocietyDTO.Info> getListById(Long id){
        return modelMapper.map(dao.findAllByTclassId(id), new TypeToken<List<TargetSocietyDTO.Info>>(){}.getType());
    }

}
