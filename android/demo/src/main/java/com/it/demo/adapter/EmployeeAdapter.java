package com.it.demo.adapter;

import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.it.core.tools.TextViewTools;
import com.it.core.tools.ViewTools;
import com.it.demo.R;
import com.it.demo.common.ViewHelper;
import com.it.demo.listener.OnImageLoaded;
import com.it.demo.model.Employee;

import java.util.List;

import de.hdodenhof.circleimageview.CircleImageView;

/**
 * Адаптер заполнения списка сотрудников
 */
public class EmployeeAdapter extends ArrayAdapter<Employee> implements OnImageLoaded {
	private LayoutInflater mInflater;
	private List<Employee> mItems;

	/**
	 * Конструктор
	 * @param context Контекст
	 * @param employees Список сотрудников
	 */
	public EmployeeAdapter(Context context, List<Employee> employees) {
		super(context, R.layout.employee_item, employees);
		mInflater = (LayoutInflater) context.getSystemService( Context.LAYOUT_INFLATER_SERVICE );
		mItems = employees;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder viewHolder;
		if (convertView == null) {
			convertView = mInflater.inflate(R.layout.employee_item, parent, false);
			viewHolder = new ViewHolder();
			viewHolder.fio = (TextView) convertView.findViewById(R.id.employee_item_fio);
			viewHolder.department = (TextView) convertView.findViewById(R.id.employee_item_department);
			viewHolder.onlineStatus = (ImageView) convertView.findViewById(R.id.employee_item_online_status);
			viewHolder.photo = (CircleImageView) convertView.findViewById(R.id.employee_item_photo);
			convertView.setTag(viewHolder);
		} else {
			viewHolder = (ViewHolder) convertView.getTag();
		}
		// Получение сотрудника по позиции в списке
		Employee item = mItems.get(position);
		// Заполнение визуальных элементов данными
		TextViewTools.setText(viewHolder.fio, item.getFio());
		TextViewTools.setText(viewHolder.department, item.getDepartment());
		TextViewTools.setText(viewHolder.nkdk, item.getNkdk().trim(), "(", ")");
		ViewTools.setCircleImageView(viewHolder.onlineStatus, item.getIsOnline() ? getContext().getResources().getColor(R.color.blue_dark) : Color.TRANSPARENT);
		ViewHelper.setPhoto(getContext(), viewHolder.photo, item.getNkdk(), item.getLogin(), this);
		return convertView;
	}

	// Обработка загрузки фотографии
	@Override
	public void onImageLoaded() {
		notifyDataSetChanged();
	}

	// Класс для сохранения во внешний класс и для ограничения доступа
	// из потомков класса
	private static class ViewHolder {
		TextView fio;
		TextView department;
		TextView nkdk;
		ImageView onlineStatus;
		CircleImageView photo;
	}
}