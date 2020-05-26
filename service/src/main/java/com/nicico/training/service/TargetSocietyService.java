package com.nicico.training.service;

import com.nicico.training.dto.TargetSocietyDTO;
import com.nicico.training.model.TargetSociety;
import com.nicico.training.repository.TargetSocietyDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class TargetSocietyService extends BaseService<TargetSociety, Long, TargetSocietyDTO.Info, TargetSocietyDTO.Create, TargetSocietyDTO.Update, TargetSocietyDTO.Delete, TargetSocietyDAO> {

    @Transactional
    public List<TargetSocietyDTO.Info> coustomCreate(List<Long>ids, List<String>titles, Long typeId, Long tclassId){
        /*List<TargetSocietyDTO.Info> result = new ArrayList<>();

        if(typeId == 1){
            for(Long id : ids){
                TargetSocietyDTO.Create create = new TargetSocietyDTO.Create();
                create.setSocietyId(id);
                create.setTargetSocietyTypeId(typeId);
                create.setTclassId(tclassId);
                result.add(super.create(create));
            }
        }else if(typeId == 2){
            for(String title : titles){
                TargetSocietyDTO.Create create = new TargetSocietyDTO.Create();
                create.setTitle(title);
                create.setTargetSocietyTypeId(typeId);
                create.setTclassId(tclassId);
                result.add(super.create(create));
            }
        }
        return result;*/
        TargetSocietyDTO.Create create = new TargetSocietyDTO.Create();
        create.setTitle("test");
        create.setTclassId(new Long(1));
        create.setTargetSocietyTypeId(new Long(1));
        create.setSocietyId(new Long(1));
        super.create(create);
        return null;
    }

}
