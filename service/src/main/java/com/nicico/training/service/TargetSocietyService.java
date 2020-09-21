package com.nicico.training.service;

import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CompetenceWebserviceDTO;
import com.nicico.training.dto.DepartmentDTO;
import com.nicico.training.dto.TargetSocietyDTO;
import com.nicico.training.model.TargetSociety;
import com.nicico.training.repository.TargetSocietyDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

@Service
@RequiredArgsConstructor
public class TargetSocietyService extends BaseService<TargetSociety, Long, TargetSocietyDTO.Info, TargetSocietyDTO.Create, TargetSocietyDTO.Update, TargetSocietyDTO.Delete, TargetSocietyDAO> {

    @Autowired
    TargetSocietyService(TargetSocietyDAO targetSocietyDAO, ParameterValueService parameterValueService, DepartmentService departmentService) {
        super(new TargetSociety(), targetSocietyDAO);
        this.parameterValueService = parameterValueService;
        this.departmentService = departmentService;
    }

    private final ParameterValueService parameterValueService;
    private final DepartmentService departmentService;

//    @Transactional
//    public List<TargetSocietyDTO.Info> coustomListCreate(List<Object> societies, Long typeId, Long tclassId){
//        List<TargetSocietyDTO.Info> result = new ArrayList<>();
//
//        for(Object society : societies){
//            TargetSocietyDTO.Create create = new TargetSocietyDTO.Create();
//            if(typeId == 1)
//                create.setSocietyId(((Integer) society).longValue());
//            else if(typeId == 2)
//                create.setTitle((String) society);
//            create.setTargetSocietyTypeId(new Long(214));
//            create.setTclassId(tclassId);
//            result.add(super.create(create));
//        }
//
//        return result;
//    }

    @Transactional(readOnly = true)
    public List<TargetSocietyDTO.Info> getTargetSocietiesById(Iterator<TargetSocietyDTO.Info> infoIterator,Long targetTypeId) {
        Long typeId = parameterValueService.getId("single");
        String type = parameterValueService.get(targetTypeId).getCode();
        Integer count = 0;
        SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq();

        List<TargetSocietyDTO.Info> infoList = new ArrayList<>();
        List<Long> targetIds = new ArrayList<>();
        while (infoIterator.hasNext()) {
            TargetSocietyDTO.Info info = infoIterator.next();
            if (typeId.equals(targetTypeId)) {
                targetIds.add(info.getSocietyId());
                count++;
            } else {
                info.setTargetSocietyTypeId(targetTypeId);
                infoList.add(info);
            }
        }

        if(type.equals("single") && targetIds != null && !targetIds.isEmpty()) {
            SearchDTO.CriteriaRq criteria = makeNewCriteria("id", targetIds, EOperator.inSet, null);
            searchRq.setCriteria(criteria);
            searchRq.setCount(count);
            SearchDTO.SearchRs<DepartmentDTO.Info> departments = departmentService.search(searchRq);

        for(DepartmentDTO.Info deparment : departments.getList()){
            TargetSocietyDTO.Info info = new TargetSocietyDTO.Info();
            info.setSocietyId(deparment.getId());
            info.setTitle(deparment.getTitle());
            info.setTargetSocietyTypeId(targetTypeId);
            infoList.add(info);
        }
        }

            return infoList;
    }

    @Transactional
    public List<TargetSocietyDTO.Info> getListById(Long id){
        return modelMapper.map(dao.findAllByTclassId(id), new TypeToken<List<TargetSocietyDTO.Info>>(){}.getType());
    }
}
