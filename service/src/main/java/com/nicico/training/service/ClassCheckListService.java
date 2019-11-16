package com.nicico.training.service;


import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.ClassCheckListDTO;
import com.nicico.training.iservice.IClassCheckListService;
import com.nicico.training.model.CheckList;
import com.nicico.training.model.CheckListItem;
import com.nicico.training.model.ClassCheckList;
import com.nicico.training.repository.CheckListDAO;
import com.nicico.training.repository.CheckListItemDAO;
import com.nicico.training.repository.ClassCheckListDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.MultiValueMap;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class ClassCheckListService implements IClassCheckListService {

    private final ClassCheckListDAO classCheckListDAO;
    private final CheckListItemDAO checkListItemDAO;
    private final CheckListDAO checkListDAO;
    private final ModelMapper mapper;

    @Transactional(readOnly = true)
    @Override
    public ClassCheckListDTO.Info get(Long id) {
        final Optional<ClassCheckList> optionalClassCheckList = classCheckListDAO.findById(id);
        final ClassCheckList classCheckList = optionalClassCheckList.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.ClassCheckListNotFound));
        return mapper.map(classCheckList, ClassCheckListDTO.Info.class);
    }

    @Transactional
    @Override
    public List<ClassCheckListDTO.Info> list() {
        List<ClassCheckList> classCheckList = classCheckListDAO.findAll();
        return mapper.map(classCheckList, new TypeToken<List<ClassCheckListDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public ClassCheckListDTO.Info create(ClassCheckListDTO.Create request) {
        ClassCheckList classCheckList = mapper.map(request, ClassCheckList.class);
        return mapper.map(classCheckListDAO.saveAndFlush(classCheckList), ClassCheckListDTO.Info.class);
    }

    @Transactional
    @Override
    public ClassCheckListDTO.Info update(Long id, ClassCheckListDTO.Update request) {
        Optional<ClassCheckList> optionalClassCheckList = classCheckListDAO.findById(id);
        ClassCheckList currentClassCheckList = optionalClassCheckList.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CheckListNotFound));
        ClassCheckList classCheckList = new ClassCheckList();
        mapper.map(currentClassCheckList, classCheckList);
        mapper.map(request, classCheckList);
        return mapper.map(classCheckListDAO.saveAndFlush(classCheckList), ClassCheckListDTO.Info.class);
    }

    @Transactional
    @Override
    public void delete(Long id) {

        classCheckListDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(ClassCheckListDTO.Delete request) {
        final List<ClassCheckList> classCheckList = classCheckListDAO.findAllById(request.getIds());
        classCheckListDAO.deleteAll(classCheckList);
    }

    @Transactional
    @Override
    public SearchDTO.SearchRs<ClassCheckListDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(classCheckListDAO, request, classCheckList -> mapper.map(classCheckList, ClassCheckListDTO.Info.class));
    }


    @Transactional
    @Override
    public List<ClassCheckListDTO.Info> fillTable(Long classId) {

        List<ClassCheckList> classCheckList = new ArrayList<>();
        List<Long> checkListItemIdsByTclassId = classCheckListDAO.getCheckListItemIdsByTclassId(classId);
        //لیستی از checklistItemID را از جدول classchecklist  بر می گرداند که tclassid برابر با classid است

        final List<CheckListItem> checkListItemTotal = checkListItemDAO.findAll();

        for (CheckListItem x : checkListItemTotal) {
            if (!checkListItemIdsByTclassId.contains(x.getId()) && (x.getIsDeleted()==null) ) {
                ClassCheckList classCheckList1 = new ClassCheckList();
                classCheckList1.setTclassId(classId);
                classCheckList1.setCheckListItemId(x.getId());
                classCheckList.add(classCheckList1);
            }

        }
        List<ClassCheckList> save = classCheckListDAO.saveAll(classCheckList);
        return mapper.map(save, new TypeToken<List<ClassCheckListDTO.Info>>() {
        }.getType());
    }

 @Transactional
    @Override
    public TotalResponse<ClassCheckListDTO.Info> newSearch(MultiValueMap criteria){
                final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        TotalResponse<ClassCheckListDTO.Info> search = SearchUtil.search(classCheckListDAO, nicicoCriteria, e ->  mapper.map(e, ClassCheckListDTO.Info.class));
        return search;

    }

    @Transactional
    @Override
    public ClassCheckListDTO.Info updateDescription(Long id, ClassCheckListDTO.Update request) throws IOException {
    Optional<ClassCheckList> optionalCheckListItem = classCheckListDAO.findById(id);
        ClassCheckList currentClassCheckList = optionalCheckListItem.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.ClassCheckListNotFound));
        ClassCheckList classCheckList = new ClassCheckList();
        mapper.map(currentClassCheckList, classCheckList);
        mapper.map(request, classCheckList);
        return mapper.map(classCheckListDAO.saveAndFlush(classCheckList),ClassCheckListDTO.Info.class);
    }



    @Transactional
    @Override
    public ClassCheckListDTO.Info updateDescriptionCheck(MultiValueMap<String, String> body) throws IOException {
        Long id = Long.parseLong(body.get("id").get(0));
        ClassCheckList classCheckList = classCheckListDAO.findById(id).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.ClassCheckListNotFound));
        Set<String> strings = body.keySet();

        if (strings.contains("enableStatus")) {
            String enableStatus = body.get("enableStatus").get(0);

            Boolean status = enableStatus.toLowerCase().equals("true") ? true : false;
            classCheckList.setEnableStatus(status);
        }
        if (strings.contains("description")) {
            String description = body.get("description").get(0);

            classCheckList.setDescription(description);
        }
        ClassCheckListDTO.Info update = update(id, mapper.map(classCheckList, ClassCheckListDTO.Update.class));
        return mapper.map(classCheckList, ClassCheckListDTO.Info.class);
    }


}
