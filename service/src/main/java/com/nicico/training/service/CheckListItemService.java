package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CheckListItemDTO;
import com.nicico.training.iservice.ICheckListItemService;
import com.nicico.training.model.CheckListItem;
import com.nicico.training.repository.CheckListItemDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor

public class CheckListItemService implements ICheckListItemService {
    private final CheckListItemDAO checkListItemDAO;
    private final ModelMapper mapper;

    @Transactional(readOnly = true)
    @Override
    public CheckListItemDTO.Info get(Long id) {
        final Optional<CheckListItem> optionalCheckListItem = checkListItemDAO.findById(id);
        final CheckListItem checkListItem = optionalCheckListItem.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CheckListNotFound));
        return mapper.map(checkListItem, CheckListItemDTO.Info.class);
    }

    @Transactional
    @Override
    public List<CheckListItemDTO.Info> list() {
        List<CheckListItem> checkListItem = checkListItemDAO.findAll();
        return mapper.map(checkListItem, new TypeToken<List<CheckListItemDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public CheckListItemDTO.Info create(CheckListItemDTO.Create request) {
        CheckListItem checkListItem = mapper.map(request, CheckListItem.class);
        return mapper.map(checkListItemDAO.saveAndFlush(checkListItem), CheckListItemDTO.Info.class);
    }

    @Transactional
    @Override
    public CheckListItemDTO.Info update(Long id, CheckListItemDTO.Update request) {
        Optional<CheckListItem> optionalCheckListItem = checkListItemDAO.findById(id);
        CheckListItem currentCheckListItem = optionalCheckListItem.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CheckListItemNotFound));
        CheckListItem checkListItem = new CheckListItem();
        mapper.map(currentCheckListItem, checkListItem);
        mapper.map(request, checkListItem);
        return mapper.map(checkListItemDAO.saveAndFlush(checkListItem), CheckListItemDTO.Info.class);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        checkListItemDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(CheckListItemDTO.Delete request) {
        final List<CheckListItem> checkListItem = checkListItemDAO.findAllById(request.getIds());
        checkListItemDAO.deleteAll(checkListItem);
    }

    @Transactional
    @Override
    public SearchDTO.SearchRs<CheckListItemDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(checkListItemDAO, request, checkList -> mapper.map(checkList, CheckListItemDTO.Info.class));
    }


    @Transactional
    @Override
    public CheckListItemDTO.Info updateDescription(Long id, CheckListItemDTO.Update request) throws IOException {
        Optional<CheckListItem> optionalCheckListItem = checkListItemDAO.findById(id);
        CheckListItem currentCheckListItem = optionalCheckListItem.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CheckListItemNotFound));
        CheckListItem checkListItem = new CheckListItem();
        mapper.map(currentCheckListItem, checkListItem);
        mapper.map(request, checkListItem);
        return mapper.map(checkListItemDAO.saveAndFlush(checkListItem), CheckListItemDTO.Info.class);

    }


    @Transactional
    @Override
    public CheckListItemDTO.Info is_Delete(Long id, CheckListItemDTO.Update request) {
        Optional<CheckListItem> optionalCheckListItem = checkListItemDAO.findById(id);
        CheckListItem currentCheckListItem = optionalCheckListItem.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CheckListItemNotFound));
        CheckListItem checkListItem = new CheckListItem();
        mapper.map(currentCheckListItem, checkListItem);
        checkListItem.setIsDeleted(true);
        return mapper.map(checkListItemDAO.saveAndFlush(checkListItem), CheckListItemDTO.Info.class);
    }


}
