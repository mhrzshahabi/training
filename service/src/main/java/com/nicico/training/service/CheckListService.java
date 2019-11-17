package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CheckListDTO;
import com.nicico.training.dto.CheckListItemDTO;
import com.nicico.training.iservice.ICheckListService;
import com.nicico.training.model.CheckList;
import com.nicico.training.model.CheckListItem;
import com.nicico.training.repository.CheckListDAO;
import com.nicico.training.repository.ClassCheckListDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class CheckListService implements ICheckListService {

    private final CheckListDAO checkListDAO;
    private final ClassCheckListDAO classCheckListDAO;
    private final ModelMapper mapper;

    @Transactional(readOnly = true)
    @Override
    public CheckListDTO.Info get(Long id) {
        final Optional<CheckList> optionalCheckList = checkListDAO.findById(id);
        final CheckList checkList = optionalCheckList.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CheckListNotFound));
        return mapper.map(checkList, CheckListDTO.Info.class);
    }

    @Transactional
    @Override
    public List<CheckListDTO.Info> list() {
        List<CheckList> checkLists = checkListDAO.findAll();
        return mapper.map(checkLists, new TypeToken<List<CheckListDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public CheckListDTO.Info create(CheckListDTO.Create request) {
        CheckList checkList = mapper.map(request, CheckList.class);
        return mapper.map(checkListDAO.saveAndFlush(checkList), CheckListDTO.Info.class);
    }

    @Transactional
    @Override
    public CheckListDTO.Info update(Long id, CheckListDTO.Update request) {
        Optional<CheckList> optionalCheckList = checkListDAO.findById(id);
        CheckList currentCheckList = optionalCheckList.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CheckListNotFound));
        CheckList checkList = new CheckList();
        mapper.map(currentCheckList, checkList);
        mapper.map(request, checkList);
        return mapper.map(checkListDAO.saveAndFlush(checkList), CheckListDTO.Info.class);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        checkListDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(CheckListDTO.Delete request) {
        final List<CheckList> checkList = checkListDAO.findAllById(request.getIds());
        checkListDAO.deleteAll(checkList);
    }

    @Transactional
    @Override
    public SearchDTO.SearchRs<CheckListDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(checkListDAO, request, checkList -> mapper.map(checkList, CheckListDTO.Info.class));
    }

    @Transactional
    @Override
    public List<CheckListItemDTO.Info> getCheckListItem(Long CheckListId) {

        final Optional<CheckList> optionalCheckList =checkListDAO.findById(CheckListId);
        final CheckList checkList = optionalCheckList.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CheckListNotFound));
        return mapper.map(checkList.getCheckListItems(), new TypeToken<List<CheckListItemDTO.Info>>() {
        }.getType());
    }

    @Override
    @Transactional
    public boolean checkForDelete(Long checkListId)
  {
    List<Long> checkListItemList=null;
  Optional<CheckList> CheckList=checkListDAO.findById(checkListId);
  final CheckList checkList=CheckList.orElseThrow(()->new TrainingException(TrainingException.ErrorType.CommitteeNotFound));
  Set<CheckListItem> checkListItemSet=checkList.getCheckListItems();
      for (CheckListItem x:checkListItemSet) {

            checkListItemList= classCheckListDAO.getCheckListItemIdsBychecklistItemId(x.getId());
          if(checkListItemList.size() > 0 && checkListItemList !=null)
          break;
      }

   return ((checkListItemList != null && checkListItemList.size()>0 ?false:true));
  }
}
